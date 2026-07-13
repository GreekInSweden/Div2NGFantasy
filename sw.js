// ---- Web Push (bakgrundsnotiser) - ren webbstandard, inget SDK behövs ----
self.addEventListener("push", (event) => {
  let payload = { title: "Familjenotiser", body: "" };
  try {
    payload = event.data ? event.data.json() : payload;
  } catch (e) {
    payload.body = event.data ? event.data.text() : "";
  }

  const options = {
    body: payload.body || "",
    icon: "/icons/icon-192.png",
    badge: "/icons/icon-192.png",
    data: payload.data || {}
  };

  event.waitUntil(self.registration.showNotification(payload.title || "Familjenotiser", options));
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: "window" }).then((clientsArr) => {
      const hadWindow = clientsArr.find((c) => "focus" in c);
      if (hadWindow) return hadWindow.focus();
      return clients.openWindow("/");
    })
  );
});

// ---- Enkel offline-cache så appen går att öppna även utan nät ----
const CACHE_NAME = "familjenotiser-v3";
const CORE_ASSETS = ["/", "/index.html", "/style.css", "/app.js", "/config.js", "/manifest.json"];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(CORE_ASSETS)).catch(() => {})
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return;
  if (event.request.url.includes("/api/")) return;
  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request))
  );
});
