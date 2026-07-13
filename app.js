import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabase = createClient(self.SUPABASE_URL, self.SUPABASE_ANON_KEY);

const LS_NAME = "familjenotiser_namn";
const LS_PIN = "familjenotiser_pin";

function getMyPin() {
  return localStorage.getItem(LS_PIN) || "";
}

function setMyPin(pin) {
  localStorage.setItem(LS_PIN, pin);
}

const whoScreen = document.getElementById("who-screen");
const pinScreen = document.getElementById("pin-screen");
const pinInput = document.getElementById("pin-input");
const pinError = document.getElementById("pin-error");
const permissionScreen = document.getElementById("permission-screen");
const mainScreen = document.getElementById("main-screen");
const whoList = document.getElementById("who-list");
const meName = document.getElementById("me-name");
const quickButtons = document.getElementById("quick-buttons");
const customText = document.getElementById("custom-text");
const recipientsEl = document.getElementById("recipients");
const sendBtn = document.getElementById("send-btn");
const sendStatus = document.getElementById("send-status");
const notifBanner = document.getElementById("notif-banner");
const receiverView = document.getElementById("receiver-view");
const senderView = document.getElementById("sender-view");
const notifToggleBtn = document.getElementById("notif-toggle-btn");
const toggleLabel = document.getElementById("toggle-label");
const switchUserBtn = document.getElementById("switch-user-btn");
const messageFeed = document.getElementById("message-feed");
const noMessages = document.getElementById("no-messages");
const toast = document.getElementById("toast");

function showScreen(el) {
  [whoScreen, pinScreen, permissionScreen, mainScreen].forEach(s => s.classList.add("hidden"));
  el.classList.remove("hidden");
}

function getMe() {
  return localStorage.getItem(LS_NAME);
}

function setMe(name) {
  localStorage.setItem(LS_NAME, name);
}

// base64url -> Uint8Array, krävs av PushManager.subscribe
function urlBase64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const rawData = atob(base64);
  return Uint8Array.from([...rawData].map(c => c.charCodeAt(0)));
}

// ---------- Steg 1: Registrera service worker ----------
async function registerSW() {
  if (!("serviceWorker" in navigator)) return null;
  try {
    return await navigator.serviceWorker.register("/sw.js");
  } catch (e) {
    console.error("SW-registrering misslyckades", e);
    return null;
  }
}

// ---------- Steg 2: Vem är jag ----------
let pendingName = null;

function renderWhoScreen() {
  whoList.innerHTML = "";
  (self.FAMILY_MEMBERS || []).forEach(name => {
    const btn = document.createElement("button");
    btn.className = "name-option";
    btn.textContent = name;
    btn.onclick = () => {
      const requiresPin = (self.ADMINS || []).includes(name) &&
        self.ADMIN_PINS && self.ADMIN_PINS[name];
      if (requiresPin) {
        pendingName = name;
        pinInput.value = "";
        pinError.classList.add("hidden");
        showScreen(pinScreen);
        setTimeout(() => pinInput.focus(), 50);
      } else {
        setMe(name);
        afterPickedName();
      }
    };
    whoList.appendChild(btn);
  });
  showScreen(whoScreen);
}

function confirmPin() {
  if (!pendingName) return;
  const expected = self.ADMIN_PINS && self.ADMIN_PINS[pendingName];
  if (pinInput.value === expected) {
    setMe(pendingName);
    setMyPin(pinInput.value);
    pendingName = null;
    afterPickedName();
  } else {
    pinError.classList.remove("hidden");
    pinInput.value = "";
    pinInput.focus();
  }
}

async function afterPickedName() {
  if (Notification && Notification.permission === "granted") {
    await activateNotifications();
    renderMain();
  } else {
    showScreen(permissionScreen);
  }
}

// ---------- Steg 3: Aktivera notiser + spara push-prenumeration ----------
async function activateNotifications() {
  try {
    const reg = await registerSW();
    if (!reg) return false;

    const permission = await Notification.requestPermission();
    if (permission !== "granted") {
      updateNotifBanner();
      return false;
    }

    let subscription = await reg.pushManager.getSubscription();
    if (!subscription) {
      subscription = await reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(self.VAPID_PUBLIC_KEY)
      });
    }

    const sub = subscription.toJSON();
    const me = getMe();

    const { error } = await supabase.from("push_subscriptions").upsert(
      {
        member_name: me,
        endpoint: sub.endpoint,
        p256dh: sub.keys.p256dh,
        auth: sub.keys.auth
      },
      { onConflict: "endpoint" }
    );
    if (error) console.error("Kunde inte spara prenumeration", error);

    updateNotifBanner();
    return true;
  } catch (e) {
    console.error("Kunde inte aktivera notiser", e);
    updateNotifBanner();
    return false;
  }
}

function updateNotifBanner() {
  if (Notification && Notification.permission !== "granted") {
    notifBanner.classList.remove("hidden");
  } else {
    notifBanner.classList.add("hidden");
  }
}

async function deactivateNotifications() {
  try {
    const reg = await navigator.serviceWorker.getRegistration();
    if (!reg) return;
    const subscription = await reg.pushManager.getSubscription();
    if (subscription) {
      const endpoint = subscription.endpoint;
      await subscription.unsubscribe();
      await supabase.from("push_subscriptions").delete().eq("endpoint", endpoint);
    }
  } catch (e) {
    console.error("Kunde inte avaktivera notiser", e);
  }
}

async function isNotifActive() {
  if (!("serviceWorker" in navigator) || Notification.permission !== "granted") return false;
  const reg = await navigator.serviceWorker.getRegistration();
  if (!reg) return false;
  const sub = await reg.pushManager.getSubscription();
  return !!sub;
}

async function renderToggle() {
  const active = await isNotifActive();
  notifToggleBtn.setAttribute("aria-pressed", active ? "true" : "false");
  toggleLabel.textContent = active ? "Notiser är på" : "Notiser är avstängda";
}

notifToggleBtn.onclick = async () => {
  notifToggleBtn.disabled = true;
  const active = await isNotifActive();
  if (active) {
    await deactivateNotifications();
  } else {
    await activateNotifications();
  }
  await renderToggle();
  notifToggleBtn.disabled = false;
};

// ---------- Steg 4: Huvudvy ----------
function renderMain() {
  const me = getMe();
  meName.textContent = me;

  loadRecentMessages();
  startRealtimeMessages();

  const isAdmin = (self.ADMINS || []).includes(me);

  if (!isAdmin) {
    senderView.classList.add("hidden");
    receiverView.classList.remove("hidden");
    notifBanner.classList.add("hidden");
    switchUserBtn.classList.add("hidden");
    renderToggle();
    showScreen(mainScreen);
    return;
  }

  switchUserBtn.classList.remove("hidden");
  receiverView.classList.add("hidden");
  senderView.classList.remove("hidden");

  quickButtons.innerHTML = "";
  (self.QUICK_MESSAGES || []).forEach(q => {
    const btn = document.createElement("button");
    btn.className = "quick-btn";
    btn.textContent = q.label;
    btn.onclick = () => sendMessage(q.text);
    quickButtons.appendChild(btn);
  });

  recipientsEl.innerHTML = "";
  const others = (self.FAMILY_MEMBERS || []).filter(n => n !== me);

  const allRow = makeRecipientRow("__all__", "Alla", false);
  recipientsEl.appendChild(allRow.wrapper);

  const personRows = others.map(name => makeRecipientRow(name, name, false));
  personRows.forEach(r => recipientsEl.appendChild(r.wrapper));

  allRow.checkbox.addEventListener("change", () => {
    if (allRow.checkbox.checked) {
      personRows.forEach(r => r.checkbox.checked = false);
    }
  });
  personRows.forEach(r => {
    r.checkbox.addEventListener("change", () => {
      if (r.checkbox.checked) allRow.checkbox.checked = false;
    });
  });

  updateNotifBanner();
  showScreen(mainScreen);
}

function makeRecipientRow(value, label, checkedByDefault) {
  const wrapper = document.createElement("label");
  wrapper.className = "recipient";
  const checkbox = document.createElement("input");
  checkbox.type = "checkbox";
  checkbox.value = value;
  checkbox.checked = checkedByDefault;
  const span = document.createElement("span");
  span.textContent = label;
  wrapper.appendChild(checkbox);
  wrapper.appendChild(span);
  return { wrapper, checkbox };
}

function getSelectedRecipients() {
  const checked = Array.from(recipientsEl.querySelectorAll("input:checked")).map(c => c.value);
  if (checked.includes("__all__")) {
    return (self.FAMILY_MEMBERS || []).filter(n => n !== getMe());
  }
  return checked;
}

async function sendMessage(presetText) {
  const me = getMe();
  const body = (presetText !== undefined ? presetText : customText.value.trim());
  const to = getSelectedRecipients();

  if (!body) {
    setStatus("Skriv ett meddelande eller välj en snabbknapp.", "err");
    return;
  }
  if (to.length === 0) {
    setStatus("Välj minst en mottagare.", "err");
    return;
  }

  setStatus("Skickar...", "");
  sendBtn.disabled = true;

  try {
    const res = await fetch("/api/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-App-Secret": self.APP_SECRET || "",
        "X-Admin-Pin": getMyPin()
      },
      body: JSON.stringify({ from: me, to, body })
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || "Okänt fel");

    setStatus(`Skickat till ${to.join(", ")} ✅`, "ok");
    customText.value = "";
  } catch (e) {
    console.error(e);
    setStatus("Kunde inte skicka: " + e.message, "err");
  } finally {
    sendBtn.disabled = false;
  }
}

function setStatus(text, cls) {
  sendStatus.textContent = text;
  sendStatus.className = "status" + (cls ? " " + cls : "");
  if (cls === "ok") {
    setTimeout(() => { sendStatus.textContent = ""; }, 4000);
  }
}

function showToast(text) {
  toast.textContent = "🔔 " + text;
  toast.classList.remove("hidden");
  setTimeout(() => toast.classList.add("hidden"), 5000);
}

function formatTime(iso) {
  const d = new Date(iso);
  const now = new Date();
  const sameDay = d.toDateString() === now.toDateString();
  if (sameDay) {
    return d.toLocaleTimeString("sv-SE", { hour: "2-digit", minute: "2-digit" });
  }
  return d.toLocaleDateString("sv-SE", { day: "numeric", month: "short" }) +
    " " + d.toLocaleTimeString("sv-SE", { hour: "2-digit", minute: "2-digit" });
}

function isRelevantToMe(msg) {
  const me = getMe();
  return msg.from_name === me || (msg.to_names || []).includes(me);
}

function renderMessageList(messages) {
  messageFeed.innerHTML = "";
  if (!messages || messages.length === 0) {
    noMessages.classList.remove("hidden");
    return;
  }
  noMessages.classList.add("hidden");
  messages.forEach(msg => {
    const item = document.createElement("div");
    item.className = "message-item";
    const top = document.createElement("div");
    top.className = "msg-top";
    const from = document.createElement("span");
    from.className = "msg-from";
    from.textContent = msg.from_name;
    const time = document.createElement("span");
    time.className = "msg-time";
    time.textContent = formatTime(msg.created_at);
    top.appendChild(from);
    top.appendChild(time);
    const body = document.createElement("div");
    body.className = "msg-body";
    body.textContent = msg.body;
    item.appendChild(top);
    item.appendChild(body);
    messageFeed.appendChild(item);
  });
}

async function loadRecentMessages() {
  const me = getMe();
  const { data, error } = await supabase
    .from("messages")
    .select("from_name, to_names, body, created_at")
    .order("created_at", { ascending: false })
    .limit(30);

  if (error) {
    console.error("Kunde inte hämta meddelanden", error);
    return;
  }

  const relevant = (data || []).filter(msg =>
    msg.from_name === me || (msg.to_names || []).includes(me)
  ).slice(0, 5);

  renderMessageList(relevant);
}

let realtimeStarted = false;
function startRealtimeMessages() {
  if (realtimeStarted) return;
  realtimeStarted = true;

  supabase
    .channel("messages-feed")
    .on(
      "postgres_changes",
      { event: "INSERT", schema: "public", table: "messages" },
      (payload) => {
        const msg = payload.new;
        if (!isRelevantToMe(msg)) return;
        const existing = messageFeed.querySelectorAll(".message-item");
        if (existing.length === 0) noMessages.classList.add("hidden");

        const item = document.createElement("div");
        item.className = "message-item is-new";
        const top = document.createElement("div");
        top.className = "msg-top";
        const from = document.createElement("span");
        from.className = "msg-from";
        from.textContent = msg.from_name;
        const time = document.createElement("span");
        time.className = "msg-time";
        time.textContent = formatTime(msg.created_at);
        top.appendChild(from);
        top.appendChild(time);
        const body = document.createElement("div");
        body.className = "msg-body";
        body.textContent = msg.body;
        item.appendChild(top);
        item.appendChild(body);
        messageFeed.prepend(item);

        if (msg.from_name !== getMe()) {
          showToast(msg.body);
        }
      }
    )
    .subscribe();
}

// ---------- Events ----------
document.getElementById("enable-btn").onclick = async () => {
  await activateNotifications();
  renderMain();
};
document.getElementById("skip-permission-btn").onclick = () => {
  renderMain();
};
document.getElementById("switch-user-btn").onclick = () => {
  localStorage.removeItem(LS_NAME);
  localStorage.removeItem(LS_PIN);
  renderWhoScreen();
};
document.getElementById("pin-confirm-btn").onclick = () => confirmPin();
document.getElementById("pin-cancel-btn").onclick = () => {
  pendingName = null;
  renderWhoScreen();
};
pinInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter") confirmPin();
});
document.getElementById("reenable-btn").onclick = async () => {
  await activateNotifications();
};
sendBtn.onclick = () => sendMessage(undefined);

// ---------- Start ----------
(async function start() {
  await registerSW();
  const me = getMe();
  if (!me) {
    renderWhoScreen();
  } else if (Notification && Notification.permission === "default") {
    showScreen(permissionScreen);
  } else {
    if (Notification && Notification.permission === "granted") {
      await activateNotifications();
    }
    renderMain();
  }
})();
