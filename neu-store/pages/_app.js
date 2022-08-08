import "../styles/globals.css";
import createCache from "@emotion/cache";
import { CacheProvider } from "@emotion/react";
import { StoreProvider } from "../utils/Store";
import Layout from "../components/Layout";

const clientSideEmotionCache = createCache({ key: "css" });

function MyApp({
  Component,
  pageProps,
  emotionCache = clientSideEmotionCache,
}) {
  return (
    <CacheProvider value={emotionCache}>
      <StoreProvider>
        <Layout>
        <Component {...pageProps} />
        </Layout>
      </StoreProvider>
    </CacheProvider>
  );
}

export default MyApp;
