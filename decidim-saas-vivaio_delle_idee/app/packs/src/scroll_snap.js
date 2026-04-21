document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("vertical_scroll_section");
  if (!container) return;

  const sections = Array.from(container.children);
  let isSnapping = false;

  const getCurrentIndex = () => {
    let closest = 0;
    let minDistance = Infinity;
    sections.forEach((section, i) => {
      const distance = Math.abs(section.getBoundingClientRect().top);
      if (distance < minDistance) {
        minDistance = distance;
        closest = i;
      }
    });
    return closest;
  };

  const snapTo = (section) => {
    isSnapping = true;
    section.scrollIntoView({ behavior: "smooth" });
    setTimeout(() => { isSnapping = false; }, 800);
  };

  window.addEventListener("wheel", (e) => {
    const rect = container.getBoundingClientRect();
    const inView = rect.top < window.innerHeight && rect.bottom > 0;
    if (!inView || isSnapping) {
      if (isSnapping) e.preventDefault();
      return;
    }

    const direction = e.deltaY > 0 ? 1 : -1;
    const current = getCurrentIndex();
    const target = Math.max(0, Math.min(sections.length - 1, current + direction));

    if (target !== current) {
      e.preventDefault();
      snapTo(sections[target]);
    }
  }, { passive: false });
});
