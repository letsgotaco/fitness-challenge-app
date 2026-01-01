# Fitness-Challenge-App

## Projektbeschreibung

Bei diesem Projekt der BBS 1 soll eine Webanwendung entwickelt werden, die es kleinen, privaten Gruppen ermöglicht, sportliche Challenges zu erstellen und den Fortschritt gemeinsam zu verfolgen. Die App soll durch Gamification und soziale Interaktion die Motivation steigern.

## Abhängigkeiten installieren

Um das Projek erfolgreich zu starten, müssen zunächst die folgenden Plugins im root-Verzeichnis installiert werden:

```
npm install cors
npm install mysql2
npm install express
```

Im Projektordner des Frontends müssen die folgenden Plugins installiert werden:

```
cd fitness-challenge-app
npm install -g @vue/cli
npm install vite
```

## Datenbank starten

Die Datenbank wurde mir PHPMyAdmin erstellt und läuft im Docker-Container unter `http://localhost:8080`. Starte den Docker-Container mit den folgenden Befehlen im Terminal:

```
cd Docker
docker-compose up -d
```

Um mit der Datenbank eine erfolgreiche Verbindung aufzubauen, führe den folgenden Befehl im Terminal aus:

```
node server.js
```

## Frontend starten

Starte das Frontend mit den folgenden Befehlen im Terminal:

```
cd fitness-challenge-app
npm run dev
```
