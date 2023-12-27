import { defineUserConfig } from "vuepress";
import type { DefaultThemeOptions } from 'vuepress'
import { defaultTheme } from '@vuepress/theme-default'
//extension
import { searchProPlugin } from "vuepress-plugin-search-pro";
import { externalLinkIconPlugin } from '@vuepress/plugin-external-link-icon'

//https://v2.vuepress.vuejs.org/guide/
export default defineUserConfig ({
  // lang: "ja",
  lang: 'ja-JP',
  title: "Note",
  description: "備忘録",
  dest: "docs/",
  base: "/note/",
  plugins: [
    //https://v2.vuepress.vuejs.org/reference/plugin/external-link-icon.html
    externalLinkIconPlugin({}),
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
