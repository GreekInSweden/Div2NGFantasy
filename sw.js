const CACHE='div2ng-v1';

self.addEventListener('install',e=>{
  self.skipWaiting();
  e.waitUntil(
    caches.open(CACHE).then(c=>c.addAll(['/','/index.html']))
  );
});

self.addEventListener('activate',e=>{
  e.waitUntil(
    caches.keys().then(keys=>Promise.all(
      keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))
    ))
  );
});

self.addEventListener('fetch',e=>{
  // Låt API-anrop (Supabase) alltid gå via nätverket
  if(e.request.url.includes('supabase')){
    e.respondWith(fetch(e.request));
    return;
  }
  e.respondWith(
    caches.match(e.request).then(r=>r||fetch(e.request))
  );
});
