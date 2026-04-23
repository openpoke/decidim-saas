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

  const isScrollableY = (element) => {
    if (!(element instanceof HTMLElement)) return false;
    const style = window.getComputedStyle(element);
    const canOverflow = style.overflowY === "auto" || style.overflowY === "scroll";
    return canOverflow && element.scrollHeight > element.clientHeight;
  };

  const canScrollInDirection = (element, direction) => {
    if (direction > 0) {
      return element.scrollTop + element.clientHeight < element.scrollHeight - 1;
    }

    return element.scrollTop > 1;
  };

  const hasInnerScrollableRoom = (target, section, direction) => {
    if (!(target instanceof HTMLElement)) return false;

    let node = target;

    while (node && node !== section) {
      if (isScrollableY(node) && canScrollInDirection(node, direction)) {
        return true;
      }
      node = node.parentElement;
    }

    return false;
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
    const currentSection = sections[current];

    if (currentSection && e.target instanceof Node && currentSection.contains(e.target) && hasInnerScrollableRoom(e.target, currentSection, direction)) {
      return;
    }

    const target = Math.max(0, Math.min(sections.length - 1, current + direction));

    if (target !== current) {
      e.preventDefault();
      snapTo(sections[target]);
    }
  }, { passive: false });
});
