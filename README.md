# app-dog

Protótipo do aplicativo para hotel, creche, adestramento, Táxi Dog e banho e tosa,
com as áreas do Tutor, da Equipe e do Proprietário. Identidade visual da SPS.

Feito em Flutter (Android, iOS e web).

## Rodar localmente

```bash
flutter pub get
flutter run -d chrome
```

## Publicar na Vercel

A Vercel serve a pasta `public/`, que é a versão web já compilada (veja `vercel.json`).
Depois de alterar o código, gere de novo e faça commit:

```bash
flutter build web --release
rm -rf public && cp -r build/web public
```
