import * as ReactDOMClient from 'react-dom/client';

// import { MainApp } from 'main/App';

const entrypointElement = document.getElementById('root_entrypoint');

if (!entrypointElement) throw new Error('Root element not found');

const root = ReactDOMClient.createRoot(entrypointElement);

console.log('ROOT, ', root);

root.render(
    <div>
        <p>ОКАК</p>
    </div>
);
