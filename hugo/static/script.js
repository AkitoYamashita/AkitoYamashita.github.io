/**
 * サイドバーの幅を保存・復元する
 */
const root = document.documentElement;
const resizer = document.querySelector(".sidebar-resizer");

const saved = localStorage.getItem("sidebar-width");
if (saved) root.style.setProperty("--sidebar-w", saved);

resizer?.addEventListener("pointerdown", e => {
	resizer.setPointerCapture(e.pointerId);

	const move = e => {
		// ドラッグ中の幅を100〜600pxに制限
		const width = Math.max(100, Math.min(600, e.clientX));
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

/**
 * Pagefindの検索結果を無限スクロールにする
 *
 * - 「もっと見る」ボタンが表示領域に入ったら自動クリック
 * - 検索結果パネル内のスクロールにも対応
 * - PagefindによるDOM更新後も監視を継続
 */
const search = document.querySelector("#search");

if (search) {
	const loadMoreObserver = new IntersectionObserver(
		entries => {
			for (const entry of entries) {
				if (!entry.isIntersecting) continue;

				const button = entry.target;

				// 同じボタンを連続クリックしない
				loadMoreObserver.unobserve(button);

				if (!button.disabled && button.isConnected) {
					button.click();
				}
			}
		},
		{
			// 検索結果パネルのスクロール領域を基準に判定
			root: null,
			rootMargin: "0px 0px 100px 0px",
			threshold: 0
		}
	);

	// Pagefindが結果を描画・更新したらボタンを監視
	const mutationObserver = new MutationObserver(() => {
		const button = search.querySelector(
			".pagefind-ui__button"
		);

		if (button && !button.disabled) {
			loadMoreObserver.observe(button);
		}
	});

	mutationObserver.observe(search, {
		childList: true,
		subtree: true
	});
}
