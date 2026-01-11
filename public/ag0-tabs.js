function initAg0Tabs(root = document) {
  const tabsBlocks = root.querySelectorAll('tabs');

  for (const tabsEl of tabsBlocks) {
    if (tabsEl.getAttribute('data-ag0-tabs-processed') === '1') continue;
    tabsEl.setAttribute('data-ag0-tabs-processed', '1');

    const tabItems = Array.from(tabsEl.children).filter(
      (el) => el && el.tagName && el.tagName.toLowerCase() === 'tabitem'
    );
    if (tabItems.length === 0) continue;

    const wrapper = document.createElement('div');
    wrapper.className = 'ag0-tabs';

    const tabList = document.createElement('div');
    tabList.className = 'ag0-tabs__tablist';
    tabList.setAttribute('role', 'tablist');

    const panels = document.createElement('div');
    panels.className = 'ag0-tabs__panels';

    const buttons = [];
    const panelEls = [];

    tabItems.forEach((tabItem, idx) => {
      const label = tabItem.getAttribute('label') || `Tab ${idx + 1}`;
      const tabId = `ag0-tab-${Math.random().toString(36).slice(2)}-${idx}`;
      const panelId = `ag0-panel-${Math.random().toString(36).slice(2)}-${idx}`;

      const btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'ag0-tabs__tab';
      btn.setAttribute('role', 'tab');
      btn.id = tabId;
      btn.setAttribute('aria-controls', panelId);
      btn.setAttribute('aria-selected', 'false');
      btn.textContent = label;

      const panel = document.createElement('div');
      panel.className = 'ag0-tabs__panel';
      panel.setAttribute('role', 'tabpanel');
      panel.id = panelId;
      panel.setAttribute('aria-labelledby', tabId);
      panel.hidden = true;

      // Move TabItem children into the panel
      while (tabItem.firstChild) {
        panel.appendChild(tabItem.firstChild);
      }

      buttons.push(btn);
      panelEls.push(panel);
      tabList.appendChild(btn);
      panels.appendChild(panel);
    });

    const setActive = (activeIdx) => {
      buttons.forEach((btn, i) => {
        const selected = i === activeIdx;
        btn.setAttribute('aria-selected', selected ? 'true' : 'false');
        btn.classList.toggle('is-active', selected);
        panelEls[i].hidden = !selected;
      });
    };

    buttons.forEach((btn, idx) => {
      btn.addEventListener('click', () => setActive(idx));
    });

    // Default active tab
    setActive(0);

    wrapper.appendChild(tabList);
    wrapper.appendChild(panels);

    // Replace the original <Tabs> content
    tabsEl.replaceWith(wrapper);
  }
}

// Initial load
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => initAg0Tabs(document));
} else {
  initAg0Tabs(document);
}

// Astro client-side navigation (if enabled)
document.addEventListener('astro:page-load', () => initAg0Tabs(document));

