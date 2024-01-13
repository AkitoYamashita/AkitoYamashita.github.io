import { defineUserConfig } from "vuepress";
import { path } from '@vuepress/utils'
import { defaultTheme } from '@vuepress/theme-default'
import type { DefaultThemeOptions } from 'vuepress'
//extension
import { searchProPlugin } from "vuepress-plugin-search-pro";
import { externalLinkIconPlugin } from '@vuepress/plugin-external-link-icon'
import { registerComponentsPlugin } from '@vuepress/plugin-register-components'
import { copyCodePlugin } from "vuepress-plugin-copy-code2";
import { mdEnhancePlugin } from "vuepress-plugin-md-enhance";

//https://v2.vuepress.vuejs.org/guide/
export default defineUserConfig ({
  lang: 'ja-JP',
  title: "AkitoYamashita.github.io",
  description: "備忘録",
  dest: "docs/",
  base: "/",
  //public: path.resolve(__dirname, './public/'),
  // public: path.resolve(__dirname, './../../src/'),
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
    //https://v2.vuepress.vuejs.org/reference/plugin/register-components.html
    registerComponentsPlugin({ 
      componentsDir: path.resolve(__dirname, './components/'),
    }),
    //https://plugin-copy-code2.vuejs.press/
    copyCodePlugin({}),
    //https://plugin-md-enhance.vuejs.press/guide/
    mdEnhancePlugin({
      tasklist: true,
      mermaid: true,
      demo: true,
      include: true,
    }),
  ],
});
