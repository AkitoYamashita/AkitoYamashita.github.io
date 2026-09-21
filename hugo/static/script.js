const root = document.documentElement;
const resizer = document.querySelector(".sidebar-resizer");

const saved = localStorage.getItem("sidebar-width");
if (saved) root.style.setProperty("--sidebar-w", saved);

resizer?.addEventListener("pointerdown", e => {
	resizer.setPointerCapture(e.pointerId);

	const move = e => {
		const width = Math.max(160, Math.min(600, e.clientX));
		root.style.setProperty("--sidebar-w", `${width}px`);
	};

	const up = () => {
		resizer.removeEventListener("pointermove", move);
		localStorage.setItem(
			"sidebar-width",
			getComputedStyle(root).getPropertyValue("--sidebar-w").trim()
		);
	};

	resizer.addEventListener("pointermove", move);
	resizer.addEventListener("pointerup", up, { once: true });
});