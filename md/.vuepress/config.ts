import { defineUserConfig } from "vuepress";
import { viteBundler } from 'vuepress'
import { defaultTheme } from 'vuepress'
import { path } from '@vuepress/utils'

// Plugin
import { searchProPlugin } from "vuepress-plugin-search-pro";
import { externalLinkIconPlugin } from '@vuepress/plugin-external-link-icon'
import { registerComponentsPlugin } from '@vuepress/plugin-register-components'
import { copyCodePlugin } from "vuepress-plugin-copy-code2";
import { mdEnhancePlugin } from "vuepress-plugin-md-enhance";
import googleAnalyticsPlugin from '@vuepress/plugin-google-analytics';

//https://v2.vuepress.vuejs.org/guide/
export default {
  lang: 'ja-JP',
  title: "AkitoYamashita.github.io",
  description: "備忘録",
  dest: "docs/",
  base: "/",
  public: path.resolve(__dirname, './public/'),
  bundler: viteBundler(),
  theme: defaultTheme({
    navbar: [
      {
        text: 'Github',
        link: 'https://github.com/AkitoYamashita/AkitoYamashita.github.io',
      },
    ],
  }),
  plugins: [
    // https://v2.vuepress.vuejs.org/reference/plugin/external-link-icon.html
    externalLinkIconPlugin({}),
    // https://plugin-search-pro.vuejs.press/
    searchProPlugin({
      indexContent: true,
      autoSuggestions: true,
      queryHistoryCount: 5,
      resultHistoryCount: 5,
      searchDelay: 150,
      sortStrategy: "max",
    }),
    // https://v2.vuepress.vuejs.org/reference/plugin/register-components.html
    registerComponentsPlugin({ 
      componentsDir: path.resolve(__dirname, './components/'),
    }),
    // https://plugin-copy-code2.vuejs.press/
    copyCodePlugin({}),
    // https://plugin-md-enhance.vuejs.press/guide/
    mdEnhancePlugin({
      tasklist: true,
      mermaid: true,
      demo: true,
      include: true,
    }),
    // https://ecosystem.vuejs.press/plugins/analytics/google-analytics.html
    googleAnalyticsPlugin({
      id: 'G-27XRJCNG7Y',
    }),
  ],
};

