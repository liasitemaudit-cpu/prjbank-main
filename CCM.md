# CCM — NathBank & NathStore & NathNotes & NathChat

NathBank, NathStore, NathNotes et NathChat forment un écosystème full-stack développé sans framework frontend. Quatre modules communiquent entre eux sur une seule machine en local.

- NathBank — banque en ligne, frontend et backend
- NathStore — boutique e-commerce qui paye via NathBank
- NathNotes — application de notes style Apple Notes
- NathChat — messagerie temps réel par WebSocket

---

## sujet

Ce projet a été conçu par Nathanaël dans le cadre d'un Bac Pro CIEL, option SNT. Le sujet est un écosystème bancaire et commercial complet. L'audience est l'auteur, ses enseignants et les utilisateurs des outils. Le rôle principal de ce document est de décrire l'écosystème clairement, sans décor inutile.

---

## pile technique

| outil | rôle |
|-------|------|
| Node.js | exécute les serveurs backend |
| Express | framework HTTP pour les API REST |
| sql.js | base de données SQLite en mémoire (WebAssembly) |
| bcrypt | hachage des mots de passe |
| jsonwebtoken (JWT) | authentification sécurisée |
| cookie-parser | lecture des cookies httpOnly (NathNotes) |
| express-rate-limit | limitation des tentatives de connexion (NathNotes) |
| ws | serveur WebSocket (NathChat) |
| HTML/CSS/JS vanilla | frontend, ES2022 |
| VS Code + Live Server | environnement de développement, port 5500 |

---

## structure des fichiers

```
projet-banque/
├── CCM.md             cette documentation
├── index.html         portail SNT / page d'accueil NathProject
├── ADMIN.md           identifiants et clés secrètes
├── arbo.txt           arborescence du projet
├── ReadMe.md          note de rappel
├── skills.md          fiche compétence design frontend
├── .env               variables d'environnement
├── .gitignore         fichiers ignorés par Git
├── LICENSE.txt        termes de la licence MIT
├── start-all.bat      lancement Windows de tous les serveurs
│
├── banque/            backend NathBank (port 3000)
│   ├── index.js       point d'entrée + routes GitHub
│   ├── database.js    gestion SQLite
│   ├── banque.db      fichier de base de données
│   ├── seed.js        remplissage des produits
│   ├── start.bat      lancement Windows
│   ├── start.ps1      lancement PowerShell
│   ├── clear-all.js   suppression de toutes les données
│   ├── clear-*.js     suppression ciblée par table
│   ├── middleware/auth.js  vérification JWT
│   ├── routes/
│   │   ├── auth.js         inscription / connexion
│   │   ├── comptes.js      solde et dépôt
│   │   ├── transactions.js  paiements et historique
│   │   ├── admin.js        gestion produits NathStore
│   │   ├── categories.js   catégories dynamiques
│   │   ├── panier.js       panier persistant
│   │   └── commandes.js    historique des commandes
│   └── package.json
│
├── banque-frontend/   frontend NathBank
│   ├── index.html     connexion / inscription
│   ├── dashboard.html  tableau de bord
│   └── paiement.html  confirmation de paiement
│
├── nathstore/         frontend NathStore
│   ├── index.html     boutique
│   ├── admin.html     panel d'administration
│   └── admin-help.html guide d'import JSON
│
├── nathnotes/         backend + frontend NathNotes (port 3001)
│   ├── server.js      serveur Express + API REST
│   ├── index.html     application de notes, trois panneaux
│   ├── help.html      guide d'utilisation
│   ├── nathnotes.db   base de données
│   └── package.json
│
└── nathchat/          backend + frontend NathChat (port 3002)
    ├── server.js      serveur Express + WebSocket
    ├── public/index.html  interface de chat
    ├── package.json
    └── README.md
```

---

## serveurs et ports

| service | port | url |
|---------|------|-----|
| NathBank API | 3000 | http://localhost:3000 |
| NathNotes API | 3001 | http://localhost:3001 |
| NathChat API + WebSocket | 3002 | http://localhost:3002 |
| Frontend (Live Server) | 5500 | http://127.0.0.1:5500 |

### lancement avec start-all.bat (Windows)

depuis la racine du projet :

```
start-all.bat
```

le script lance le serveur Banque (port 3000), le serveur NathNotes (port 3001), puis ouvre NathBank, NathStore et NathNotes dans le navigateur.

### lancement manuel

```
# 1. serveur Banque (port 3000)
cd banque && node index.js

# 2. serveur NathNotes (port 3001)
cd nathnotes && node server.js

# 3. serveur NathChat (port 3002)
cd nathchat && node server.js

# 4. ouvrir les frontends avec Live Server sur le port 5500
```

urls utiles :
- NathBank : http://127.0.0.1:5500/banque-frontend
- NathStore : http://127.0.0.1:5500/nathstore
- NathNotes : http://127.0.0.1:5500/nathnotes
- NathChat : http://127.0.0.1:5500/nathchat
- portail SNT : http://127.0.0.1:5500/index.html
- API Banque : http://localhost:3000
- API Notes : http://localhost:3001
- API Chat : http://localhost:3002

---

## backend NathBank

### index.js

le fichier principal. il charge les variables d'environnement, crée l'application Express, active le CORS, branche toutes les routes API, ajoute les routes GitHub stats, initialise la base de données et lance le serveur sur le port 3000.

### database.js

le projet utilise sql.js, une version de SQLite compilée en WebAssembly. toute la base est chargée en mémoire RAM et sauvegardée dans banque.db à chaque écriture.

au démarrage, si banque.db existe, il est chargé en mémoire. sinon, une base vide est créée.

tables créées automatiquement :

- users — comptes utilisateurs
- comptes — comptes bancaires et solde
- transactions — historique des paiements
- produits — produits NathStore
- categories — catégories dynamiques
- admins — comptes administrateurs
- paniers — paniers sauvegardés
- commandes — commandes passées
- commandes_items — détail de chaque commande

trois fonctions utilitaires : run (écriture sans retour), get (une ligne), all (plusieurs lignes).

### middleware/auth.js

un middleware s'exécute entre la requête et la réponse. auth.js vérifie que l'utilisateur est connecté avant d'accéder aux routes protégées. le client envoie un header Authorization: Bearer <token>. le middleware extrait le token, le vérifie avec la clé secrète JWT, puis met l'utilisateur dans req.user ou retourne une erreur 401.

deux secrets JWT distincts :
- users : mon_secret_jwt_super_secure_123
- admins : admin_secret_nathstore_456

---

## routes API NathBank

### authentification (/api/auth)

POST /api/auth/register — créer un compte.
corps : { nom, email, mot_de_passe }
le mot de passe est hashé avec bcrypt (coût 10). un compte bancaire est créé automatiquement avec 100 € de solde de départ.

POST /api/auth/login — se connecter.
corps : { email, mot_de_passe }
retourne un token JWT valable 24h, le nom de l'utilisateur et un message de confirmation.

### comptes (/api/comptes) — protégé JWT

GET /api/comptes/solde — retourne le solde du compte connecté.

POST /api/comptes/deposer — déposer de l'argent.
corps : { montant }
règle : maximum 10 000 € de solde. tout dépôt dépassant cette limite est refusé.

### transactions (/api/transactions) — protégé JWT

POST /api/transactions/payer — effectuer un paiement.
corps : { montant, description }
vérifie le solde, débite le compte, enregistre la transaction, retourne le nouveau solde.

GET /api/transactions/historique — historique des transactions du compte connecté.

### admin (/api/admin) — protégé JWT admin sauf indication contraire

POST /api/admin/setup — créer le premier compte admin, protégé par une clé secrète.
corps : { email, mot_de_passe, secret }

POST /api/admin/login — connexion admin, retourne un token JWT.

GET /api/admin/produits — liste tous les produits, route publique.

POST /api/admin/produits — ajouter un produit.
corps : { nom, emoji, categorie, prix, description, badge }

PUT /api/admin/produits/:id — modifier un produit.

DELETE /api/admin/produits/:id — supprimer un produit.

### catégories (/api/categories)

GET /api/categories — liste toutes les catégories triées par ordre, route publique.

POST /api/categories — ajouter une catégorie, protégé JWT admin.
corps : { nom, emoji, ordre }
règle : le nom doit être en minuscules, sans espaces ni caractères spéciaux.

PUT /api/categories/:id — modifier une catégorie, protégé JWT admin.

DELETE /api/categories/:id — supprimer une catégorie, protégé JWT admin. refusé si des produits utilisent encore cette catégorie.

### panier (/api/panier) — protégé JWT

GET /api/panier — récupérer le panier sauvegardé.

POST /api/panier — sauvegarder ou remplacer le panier complet.
corps : { items: [{ produit_id, quantite }] }

DELETE /api/panier — vider le panier.

### commandes (/api/commandes) — protégé JWT

GET /api/commandes — toutes les commandes de l'utilisateur avec le détail des produits.

POST /api/commandes — enregistrer une nouvelle commande après paiement.
corps : { total, items: [{ produit_id, nom, emoji, prix, quantite }] }
crée la commande, insère chaque item dans commandes_items, vide automatiquement le panier.

### routes GitHub (port 3000)

GET /api/github-stats — statistiques du dépôt GitHub (langages, nombre total de commits). utilise le token GITHUB_TOKEN du fichier .env.

GET /api/github-commits — les dix derniers commits du dépôt.

---

## frontend NathBank

### banque-frontend/index.html

page d'accueil. connexion à un compte existant ou création d'un nouveau compte. lors de la connexion, le JavaScript appelle POST /api/auth/login, sauvegarde le token JWT dans localStorage et redirige vers dashboard.html.

### banque-frontend/dashboard.html

tableau de bord de l'utilisateur connecté. affiche le solde, le total dépensé, le nombre de transactions et l'historique complet. au chargement, récupère le token depuis localStorage, appelle GET /api/comptes/solde et GET /api/transactions/historique.

### banque-frontend/paiement.html

page animée de confirmation de paiement. reçoit les informations via les paramètres d'URL.

---

## frontend NathStore

### nathstore/index.html

page principale de la boutique. au chargement, récupère les catégories, génère les boutons de filtre, charge les produits. si l'utilisateur est connecté, son panier est chargé depuis la base de données.

le filtrage par catégorie fonctionne via des boutons de navigation synchronisés. la connexion est obligatoire pour acheter : un clic sur "+" sans être connecté ouvre la modal de connexion.

le panier s'ouvre depuis la droite, permet de modifier les quantités, sauvegarde automatiquement en base de données à chaque modification et affiche le total en temps réel.

le paiement suit ce flux : clic sur "payer avec NathBank", modal de confirmation avec le total et le nom de l'utilisateur, clic "confirmer" vers POST /api/transactions/payer, puis POST /api/commandes pour enregistrer la commande. le panier est vidé et une confirmation s'affiche avec le nouveau solde.

l'historique des commandes est accessible via un bouton dans la navigation, visible si connecté. un bouton de bascule permet de passer du mode clair au mode sombre via data-theme sur l'élément html.

### nathstore/admin.html

panel d'administration accessible sur http://127.0.0.1:5500/nathstore/admin.html.
connexion : email admin@nathstore.com, mot de passe admin2026. le token admin est stocké dans localStorage sous la clé adminToken.

sections : catégories (cards, formulaire d'ajout, modifier, supprimer bloqué si des produits utilisent la catégorie), import JSON (onglet coller du JSON, onglet uploader un fichier, barre de progression, message de confirmation), ajouter un produit (formulaire manuel avec select de catégorie chargé dynamiquement), gérer les produits (tableau, modifier, supprimer). stats en haut : total produits, produits actifs, prix moyen, nombre de catégories.

format JSON attendu pour l'import :
```
[
  {
    "nom": "Air Max 2026",
    "emoji": "👟",
    "categorie": "mode",
    "prix": 89.99,
    "description": "Sneakers ultra confortables",
    "badge": "NEW"
  }
]
```
champs requis : nom, emoji, categorie, prix. champs optionnels : description, badge.

### nathstore/admin-help.html

guide d'import JSON. explique le format attendu, chaque champ, les catégories disponibles, des exemples copiables, les erreurs fréquentes et des conseils.

---

## backend NathNotes (port 3001)

### server.js

serveur Express avec CORS et cookie-parser. initialise la base de données sql.js dans nathnotes.db. configure une limitation de vitesse sur les routes d'authentification (cinq tentatives par IP par quinze minutes). lance le serveur sur le port 3001.

tables créées automatiquement :

- users — email, mot de passe hashé, nom, date de création
- notes — titre, contenu, dossier, favori, suppression logicielle, horodatages
- folders — nom, icône, couleur, utilisateur

clé JWT : nathnotes_secret_key_2026
authentification : cookie token httpOnly ou header Authorization: Bearer <token>
expiration du token : sept jours

### routes API NathNotes

| méthode | route | auth | description |
|---------|-------|------|-------------|
| POST | /api/auth/register | — | créer un compte |
| POST | /api/auth/login | — | connexion, limitée en vitesse |
| GET | /api/auth/me | cookie JWT | infos utilisateur connecté |
| POST | /api/auth/logout | — | déconnexion |
| GET | /api/notes | cookie JWT | notes non supprimées |
| GET | /api/notes/deleted | cookie JWT | corbeille |
| POST | /api/notes | cookie JWT | créer une note |
| PUT | /api/notes/:id | cookie JWT | modifier une note |
| DELETE | /api/notes/:id | cookie JWT | suppression logicielle |
| POST | /api/notes/:id/restore | cookie JWT | restaurer depuis la corbeille |
| GET | /api/folders | cookie JWT | dossiers par défaut et personnalisés |
| POST | /api/folders | cookie JWT | créer un dossier |

corps d'une note : { title, content, folder }
dossiers par défaut : tout, travail, perso, idées.

route racine : GET / retourne { message: "📝 NathNotes API", version: "1.0.0" }.

---

## frontend NathNotes

### nathnotes/index.html

application de notes style Apple Notes. trois panneaux : navigation des dossiers, liste des notes, éditeur de note. modes clair et sombre, recherche, favoris, corbeille, dossiers personnalisés avec icônes et couleurs. purification HTML avec DOMPurify. l'authentification utilise un cookie httpOnly géré automatiquement par le navigateur.

### nathnotes/help.html

guide d'utilisation complet de NathNotes.

---

## backend NathChat (port 3002)

### server.js

serveur Express combiné à un serveur WebSocket. api REST pour les salons et messages, protégée par JWT. serveur WebSocket pour la messagerie temps réel. base de données sql.js dans nathchat.db.

tables créées automatiquement :

- rooms — salons de discussion (nom, type, date de création)
- messages — messages (salon, utilisateur, nom d'utilisateur, contenu, date)
- room_members — membres des salons
- reactions — réactions emoji sur les messages

salons par défaut : général, random, nathbank.

clé JWT : nathbank_secret_key (identique à NathBank)

### routes API NathChat

| méthode | route | auth | description |
|---------|-------|------|-------------|
| GET | /api/rooms | JWT | liste tous les salons |
| GET | /api/rooms/:id/messages | JWT | messages d'un salon avec réactions |
| POST | /api/rooms | JWT | créer un salon |

### événements WebSocket

| type | description |
|------|-------------|
| auth | s'authentifier avec un token JWT |
| join_room | rejoindre un salon et récupérer l'historique |
| send_message | envoyer un message dans un salon |
| react | ajouter ou retirer une réaction emoji |
| typing | indicateur de frappe dans un salon |

événements reçus du serveur : auth_ok, rooms, room_history, new_message, reaction_update, user_typing, online_users, system, error.

---

## frontend NathProject (index.html à la racine)

page de présentation du projet. loader animé avec un MacBook en CSS 3D, navigation vers NathBank, NathNotes et NathStore, section hero avec les trois applications, cartes avec animations au survol, statistiques animées, barres de progression par langage, timeline interactive du développement et récupération des commits GitHub en temps réel via l'API backend. design sombre, verre dépoli, animations au défilement.

url : http://127.0.0.1:5500/index.html

---

## scripts utilitaires

### seed.js

remplit la base de données de produits. depuis banque/ :

```
node seed.js
```

insère automatiquement vingt produits répartis dans quatre catégories de base (mode, tech, gaming, food).

### clear-*.js

scripts dans banque/ pour supprimer des données spécifiques : clear-all.js, clear-users.js, clear-produits.js, clear-categories.js, clear-paniers.js, clear-commandes.js, clear-transactions.js.

### start.bat et start.ps1

lancement du serveur Banque sur Windows, en CMD et PowerShell.

---

## comptes de test

| type | email | mot de passe | notes |
|------|-------|--------------|-------|
| utilisateur NathBank | nathanael@straumann.me | Nathlecon1234 | solde initial 100 € |
| admin NathStore | nathanael@straumann.me | Nathlecon1234 | accès panel admin |
| utilisateur NathNotes | nathanael@straumann.me | Nathlecon1234 | token dans cookie httpOnly |

---

## clés secrètes JWT

| type | secret | utilisé dans |
|------|--------|--------------|
| utilisateur NathBank | mon_secret_jwt_super_secure_123 | banque/middleware/auth.js |
| admin NathStore | admin_secret_nathstore_456 | banque/routes/admin.js, banque/routes/categories.js |
| NathNotes | nathnotes_secret_key_2026 | nathnotes/server.js |
| NathChat | nathbank_secret_key | nathchat/server.js |

---

## endpoints API rapide (NathBank)

| méthode | route | auth |
|---------|-------|------|
| POST | /api/auth/register | — |
| POST | /api/auth/login | — |
| GET | /api/comptes/solde | JWT |
| POST | /api/comptes/deposer | JWT |
| POST | /api/transactions/payer | JWT |
| GET | /api/transactions/historique | JWT |
| GET | /api/admin/produits | public |
| POST | /api/admin/produits | JWT admin |
| PUT | /api/admin/produits/:id | JWT admin |
| DELETE | /api/admin/produits/:id | JWT admin |
| GET | /api/categories | public |
| POST | /api/categories | JWT admin |
| GET | /api/panier | JWT |
| POST | /api/panier | JWT |
| DELETE | /api/panier | JWT |
| GET | /api/commandes | JWT |
| POST | /api/commandes | JWT |
| GET | /api/github-stats | — |
| GET | /api/github-commits | — |

---

## configuration Live Server

dans settings.json de VS Code, ajouter :

```
"liveServer.settings.ignoreFiles": ["**/*.db", "**/*.db-shm", "**/*.db-wal"]
```

sans cela, chaque écriture en base recharge la page automatiquement.

---

## git

```
git add .
git commit -m "description"
git push origin main
```

dépôt : https://github.com/Nathlecon/prjbank

node_modules et les fichiers .db sont ignorés via .gitignore. après un clone, faire npm install dans chaque dossier backend (banque/, nathnotes/, nathchat/).

---

## problèmes connus et solutions

| problème | cause | solution |
|----------|-------|----------|
| page qui recharge à chaque action | Live Server détecte les écritures SQLite | ajouter ignoreFiles dans settings.json |
| module manquant ./routes/categories | fichier absent | créer banque/routes/categories.js |
| erreur sqlite3 sur Windows | module compilé pour Mac | utiliser sql.js à la place |
| push Git rejeté | historiques divergents | git push origin main --force |
| HTTP 400 sur push | fichiers trop lourds | ajouter .gitignore et supprimer node_modules du suivi |
| NathNotes ne démarre pas | dépendances absentes | cd nathnotes && npm install |
| WebSocket NathChat ne connecte pas | mauvaise URL ou port | vérifier ws://localhost:3002 |

---

## architecture de communication

```
[NathStore frontend]   [NathBank frontend]   [NathNotes frontend]   [NathChat frontend]
        |                    |                      |                      |
        | fetch HTTP         | fetch HTTP           | fetch HTTP +         | fetch HTTP +
        |                    |                      | cookie httpOnly      | WebSocket
        |                    |                      |                      |
        v                    v                      v                      v
[NathBank backend 3000]  [NathNotes backend 3001] [NathChat backend 3002]
        |                      |                      |
        | sql.js               | sql.js             | sql.js
        |                      |                      |
        v                      v                      v
[banque.db]            [nathnotes.db]         [nathchat.db]
```

flux d'un achat sur NathStore :

1. l'utilisateur clique sur "+" et le système vérifie s'il est connecté
2. s'il ne l'est pas, une modal de connexion s'ouvre, puis POST /api/auth/login
3. le token JWT est stocké dans localStorage
4. le panier est chargé depuis GET /api/panier
5. chaque modification du panier est envoyée vers POST /api/panier, sauvegarde automatique
6. clic sur "payer" vers POST /api/transactions/payer, qui débite le compte
7. en cas de succès, POST /api/commandes enregistre la commande
8. le panier est vidé, une confirmation s'affiche avec le nouveau solde

---

© 2026 Nathanaël — Projet SNT · Bac Pro CIEL · KernelAndCo
