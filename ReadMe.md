# NathProject — Écosystème Bancaire & Commercial

NathBank, NathStore, NathNotes et NathChat forment un écosystème full-stack développé sans framework frontend. Quatre modules communiquent entre eux sur une seule machine en local. Ce projet a été conçu dans le cadre d'un Bac Pro CIEL, option SNT.

## Modules

| Module | Rôle | Port |
|--------|------|------|
| NathBank | Banque en ligne (auth, solde, dépôt, paiement, historique) | 3000 |
| NathStore | Boutique e-commerce qui paye via NathBank | 5500 (frontend) |
| NathNotes | Application de notes (trois panneaux, dossiers, corbeille) | 3001 |
| NathChat | Messagerie temps réel par WebSocket | 3002 |
| Frontend (Live Server) | Pages HTML/CSS/JS vanilla | 5500 |

## Arborescence

```
prjbank/
├── index.html              Portail SNT / page d'accueil
├── ReadMe.md               Ce fichier
├── ADMIN.md                Identifiants et clés (usage local uniquement)
├── CCM.md                  Cahier des charges détaillé
├── .env                    Variables d'environnement (GitHub token, secrets JWT)
├── .gitignore
├── LICENSE.txt
├── start-all.bat           Lance tous les serveurs (Windows)
│
├── banque/                 Backend NathBank (port 3000)
│   ├── index.js            Point d'entrée + routes GitHub
│   ├── database.js         Gestion SQLite (sql.js)
│   ├── banque.db           Base de données
│   ├── seed.js             Remplissage des produits
│   ├── start.bat / start.ps1
│   ├── clear-*.js          Scripts de suppression de données
│   ├── middleware/auth.js  Vérification JWT
│   ├── routes/
│   │   ├── auth.js         Inscription / connexion
│   │   ├── comptes.js      Solde et dépôt
│   │   ├── transactions.js Paiements et historique
│   │   ├── admin.js        Gestion produits NathStore
│   │   ├── categories.js   Catégories dynamiques
│   │   ├── panier.js       Panier persistant
│   │   └── commandes.js    Historique des commandes
│   └── package.json
│
├── banque-frontend/        Frontend NathBank
│   ├── index.html          Connexion / inscription
│   ├── dashboard.html      Tableau de bord
│   └── paiement.html       Confirmation de paiement
│
├── nathstore/              Frontend NathStore
│   ├── index.html          Boutique
│   ├── admin.html          Panel d'administration
│   └── admin-help.html     Guide d'import JSON
│
├── nathnotes/              Backend + frontend NathNotes (port 3001)
│   ├── server.js           Serveur Express + API REST
│   ├── index.html          Application de notes
│   ├── help.html           Guide d'utilisation
│   ├── nathnotes.db        Base de données
│   └── package.json
│
└── nathchat/               Backend + frontend NathChat (port 3002)
    ├── server.js           Serveur Express + WebSocket
    ├── public/index.html   Interface de chat
    ├── package.json
    └── README.md
```

## Lancement

### Sur Windows (recommandé)

Depuis la racine du projet :

```
start-all.bat
```

Le script lance le serveur Banque (port 3000), le serveur NathNotes (port 3001), le serveur NathChat (port 3002), puis ouvre NathBank, NathStore, NathNotes et NathChat dans le navigateur.

### Lancement manuel

```bash
# 1. Serveur Banque (port 3000)
cd banque && node index.js

# 2. Serveur NathNotes (port 3001)
cd nathnotes && node server.js

# 3. Serveur NathChat (port 3002)
cd nathchat && node server.js

# 4. Ouvrir les frontends avec Live Server sur le port 5500
```

### Prérequis

Dans chaque dossier backend (`banque/`, `nathnotes/`, `nathchat/`) :

```bash
npm install
```

## URLs

- Portail SNT : `http://127.0.0.1:5500/index.html`
- NathBank : `http://127.0.0.1:5500/banque-frontend`
- NathStore : `http://127.0.0.1:5500/nathstore`
- NathNotes : `http://127.0.0.1:5500/nathnotes`
- NathChat : `http://127.0.0.1:5500/nathchat`
- API Banque : `http://localhost:3000`
- API Notes : `http://localhost:3001`
- API Chat : `http://localhost:3002`

## Identifiants de test (développement uniquement)

Consultez `ADMIN.md`. Les mots de passe et clés secrètes y sont listés pour usage local. Ne les diffusez jamais en production.

## API rapides

| Méthode | Route | Auth |
|---------|-------|------|
| POST | `/api/auth/register` | — |
| POST | `/api/auth/login` | — |
| GET | `/api/comptes/solde` | JWT |
| POST | `/api/comptes/deposer` | JWT |
| POST | `/api/transactions/payer` | JWT |
| GET | `/api/transactions/historique` | JWT |
| GET | `/api/admin/produits` | — (public) |
| POST | `/api/admin/produits` | JWT admin |
| GET | `/api/categories` | — (public) |
| GET | `/api/panier` | JWT |
| POST | `/api/panier` | JWT |
| GET | `/api/commandes` | JWT |
| POST | `/api/commandes` | JWT |

## Problèmes connus

- La page recharge automatiquement à chaque écriture SQLite si Live Server surveille les fichiers `.db`. Ajoutez dans les paramètres VS Code Live Server :
  `"liveServer.settings.ignoreFiles": ["**/*.db", "**/*.db-shm", "**/*.db-wal"]`
- NathChat nécessite que NathBank tourne sur le port 3000 pour l'authentification (même secret JWT).
- Après un `git clone`, faites `npm install` dans chaque dossier backend.

## Licence

MIT — voir `LICENSE.txt`.

© 2026 Nathanaël — Projet SNT · Bac Pro CIEL · KernelAndCo