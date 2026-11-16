# Ecoa

**App:** https://ecoa-mu.vercel.app

Pratica escrita e compreensão oral a escrever as legendas de vídeos do YouTube. Grátis, sem conta: os vídeos, as legendas e o progresso ficam guardados no browser de cada pessoa.

## Funções

- **Três modos:** Escrever junto (o vídeo pausa em cada frase), Ditado (legendas escondidas, com dicas) e Ver (vídeo seguido, legendas duplas e transcrição clicável).
- **Legendas:** ficheiros `.srt` ou `.vtt`, ou a transcrição copiada do YouTube. A app explica passo a passo onde as encontrar.
- **Músicas:** clipes do YouTube ou ficheiros de música do computador, com letra `.lrc` ou colada. Se a letra não tiver tempos, a app ajuda a marcá-los. Organizadas por artista e álbum, com a percentagem de palavras certas.
- **Rever erros:** as frases em que erraste voltam com repetição espaçada (1, 3, 7, 14 e 30 dias). Relatório das palavras que mais falhas e das trocas mais frequentes.
- **Palavras:** carrega numa palavra da transcrição para ver o significado (inglês, via dictionaryapi.dev) e guardá-la com a frase onde a ouviste.
- **Progresso:** calendário dos dias em que praticaste e gráficos de palavras por minuto e precisão. Sem metas nem contagem de dias seguidos.
- **Conta opcional (Supabase):** login por link no email e sincronização entre dispositivos. Sem conta, tudo fica no browser.
- **Cópia de segurança** em ficheiro, tema claro e escuro, app instalável (PWA).

## Estrutura

```
index.html             a app inteira (HTML, CSS e JavaScript)
manifest.webmanifest   dados para instalar como app
sw.js                  service worker (modo offline)
privacidade.html       política de privacidade
supabase/schema.sql    tabelas e regras de segurança da base de dados
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
