const CACHE='div2ng-v3'; // bumpa denna siffra om du någon gång vill tvinga en total cache-rensning hos alla

self.addEventListener('install',e=>{
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(['/','/index.html'])).catch(()=>{}));
});

self.addEventListener('activate',e=>{
  e.waitUntil(
    caches.keys()
      .then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
      .then(()=>self.clients.claim()) // ta över redan öppna flikar direkt, ingen omladdning krävs
  );
});

self.addEventListener('fetch',e=>{
  const req=e.request;
  if(req.method!=='GET') return; // rör inte POST/PATCH osv

  if(req.url.includes('supabase')){
    e.respondWith(fetch(req));
    return;
  }

  // Appens huvudfil (index.html / "/"): hämta alltid färskast möjliga version från
  // nätverket först, så nya deployer syns direkt utan att någon behöver rensa cache.
  // Faller bara tillbaka på den sparade cachen om användaren är offline.
  const isAppShell = req.mode==='navigate' || req.url.endsWith('/') || req.url.endsWith('/index.html');
  if(isAppShell){
    e.respondWith(
      fetch(req).then(res=>{
        const resClone=res.clone();
        caches.open(CACHE).then(c=>c.put(req,resClone));
        return res;
      }).catch(()=>caches.match(req))
    );
    return;
  }

  // Övriga statiska resurser (ikoner m.m.): cache först, som tidigare – snabbt och sällan ändrat
  e.respondWith(caches.match(req).then(r=>r||fetch(req)));
});

// ── Push-notiser ─────────────────────────────────────────────────────────
self.addEventListener('push',e=>{
  if(!e.data) return;
  let data;
  try { data=e.data.json(); } catch(err){ data={title:'Div2NG Play',body:e.data.text()}; }
  e.waitUntil(
    self.registration.showNotification(data.title||'Div2NG Play',{
      body: data.body||'',
      icon: '/icon.svg',
      badge: '/icon.svg',
      vibrate: [200,100,200],
      data: { url: data.url||'/' },
      actions: [{ action:'open', title:'Öppna appen' }]
    })
  );
});

self.addEventListener('notificationclick',e=>{
  e.notification.close();
  const url=e.notification.data?.url||'/';
  e.waitUntil(
    clients.matchAll({type:'window'}).then(cs=>{
      const c=cs.find(c=>c.url===url&&'focus' in c);
      return c?c.focus():clients.openWindow(url);
    })
  );
});
