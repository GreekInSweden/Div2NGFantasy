const CACHE='div2ng-v2';

self.addEventListener('install',e=>{
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(['/','/index.html'])));
});

self.addEventListener('activate',e=>{
  e.waitUntil(caches.keys().then(keys=>Promise.all(
    keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))
  )));
});

self.addEventListener('fetch',e=>{
  if(e.request.url.includes('supabase')){
    e.respondWith(fetch(e.request));
    return;
  }
  e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request)));
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
