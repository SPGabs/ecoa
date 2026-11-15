# Ecoa

**App:** https://ecoa-mu.vercel.app

Pratica escrita e compreensão oral a escrever as legendas de vídeos do YouTube. Grátis, sem conta: os vídeos, as legendas e o progresso ficam guardados no browser de cada pessoa.

## Funções

- **Três modos:** Escrever junto (o vídeo pausa em cada frase), Ditado (legendas escondidas, com dicas) e Ver (vídeo seguido, legendas duplas e transcrição clicável).
- **Legendas:** ficheiros `.srt` ou `.vtt`, ou a transcrição copiada do YouTube ("Mostrar transcrição").
- **Legendas duplas:** um segundo ficheiro com a tradução.
- **Biblioteca** com progresso, palavras por minuto, precisão e último acesso.
- Velocidade do vídeo, repetição em ciclo, ignorar maiúsculas e pontuação, tema claro e escuro.
- **App instalável (PWA):** abre sem internet. Os vídeos do YouTube continuam a precisar de internet.

## Estrutura

```
index.html             a app inteira (HTML, CSS e JavaScript)
manifest.webmanifest   dados para instalar como app
sw.js                  service worker (modo offline)
icons/                 ícones da app
vercel.json            cabeçalhos e configuração do Vercel
```

Não há build nem dependências: o Vercel serve os ficheiros tal como estão.

## Correr localmente

```bash
python -m http.server 8000
# abre http://localhost:8000
```

Não abras o `index.html` com duplo clique: o service worker e alguns vídeos do YouTube só funcionam através de um servidor.

## Publicar

O repositório está ligado ao projeto `ecoa` no Vercel: cada `git push` para a branch `main` publica uma nova versão em https://ecoa-mu.vercel.app.

Quando publicares alterações, sobe o valor `VERSION` em `sw.js` (por exemplo `ecoa-v2`) para quem já tem a app instalada receber a versão nova.

## Mudar para o servidor dedicado

A app é estática: basta copiar estes ficheiros para a pasta pública do servidor (Nginx, Apache, etc.). Mantém o HTTPS, porque o service worker e a instalação como app só funcionam com HTTPS.
