// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

// Load images
require.context("../../images", true)

// Clear PWA pages cache on logout to prevent caching private pages like account, conversations, notifications
document.addEventListener("click", async (event) => {
  const logoutLink = event.target.closest("a[href*='/sign_out'], a[href*='/logout'], a[data-turbo-method='delete']");
  
  if (logoutLink && "caches" in window) {
    try {
      const cacheNames = await caches.keys();
      const pageCacheName = cacheNames.find(name => name.includes("pages"));
      
      if (pageCacheName) {
        await caches.delete(pageCacheName);
      }
    } catch (error) {
      console.error("Error clearing PWA cache on logout:", error);
    }
  }
});

