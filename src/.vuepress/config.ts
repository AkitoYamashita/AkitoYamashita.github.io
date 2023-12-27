import { defineUserConfig } from "vuepress";
import type { DefaultThemeOptions } from 'vuepress'
import { defaultTheme } from '@vuepress/theme-default'
import { searchProPlugin } from "vuepress-plugin-search-pro";

//https://v2.vuepress.vuejs.org/guide/
export default defineUserConfig ({
  // lang: "ja",
  lang: 'ja-JP',
  title: "Note",
  description: "備忘録",
  dest: "docs/",
  base: "/note/",
  plugins: [
    //https://plugin-search-pro.vuejs.press/
    searchProPlugin({
      indexContent: true,
      autoSuggestions: true,
      queryHistoryCount: 5,
      resultHistoryCount: 5,
      searchDelay: 150,
      sortStrategy: "max",
    }),
  ],
});
