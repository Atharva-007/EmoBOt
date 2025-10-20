// Import Firebase scripts for compatibility
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize Firebase in the service worker
const firebaseConfig = {
  apiKey: "AIzaSyC7fzZm9WKFC0mCsOHcytWblZaGYfHdkG4",
  authDomain: "emubot-38395.firebaseapp.com",
  databaseURL: "https://emubot-38395-default-rtdb.firebaseio.com",
  projectId: "emubot-38395",
  storageBucket: "emubot-38395.firebasestorage.app",
  messagingSenderId: "558979303215",
  appId: "1:558979303215:web:8b1f0442d2f5e3511011b5"
};

firebase.initializeApp(firebaseConfig);

// Get messaging instance
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  // Customize notification here
  const notificationTitle = payload.notification?.title || 'EmuBot Notification';
  const notificationOptions = {
    body: payload.notification?.body || 'You have a new message from EmuBot',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'emubot-notification',
    data: payload.data || {},
    actions: [
      {
        action: 'open',
        title: 'Open EmuBot'
      },
      {
        action: 'dismiss',
        title: 'Dismiss'
      }
    ]
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', function(event) {
  console.log('[firebase-messaging-sw.js] Notification click received.');

  event.notification.close();

  if (event.action === 'open') {
    // Open the app
    event.waitUntil(
      clients.openWindow('/')
    );
  } else if (event.action === 'dismiss') {
    // Just close the notification
    return;
  } else {
    // Default action - open the app
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});

// Install event
self.addEventListener('install', function(event) {
  console.log('[firebase-messaging-sw.js] Service worker installing...');
  self.skipWaiting();
});

// Activate event
self.addEventListener('activate', function(event) {
  console.log('[firebase-messaging-sw.js] Service worker activating...');
  event.waitUntil(self.clients.claim());
});