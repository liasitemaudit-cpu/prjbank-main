# Plan — Écosystème Nath (NathBank / NathStore / NathNotes / NathChat)

**Plan file:** `.kilo/plans/1794345970712-ecosysteme-nath-plan.md`
**Context:** Bac Pro CIEL / SNT full-stack project, vanilla JS frontends, Express + sql.js backends, ports 3000/3001/3002, frontend served via Live Server on 5500.

## État actuel (constat)

Quatre modules fonctionnels mais inachevés :
- **NathBank** (banque/ + banque-frontend/) : auth, solde, dépôt, paiement, historique, panier, commandes, catégories, produits admin, stats GitHub.
- **NathStore** (nathstore/) : catalogue, panier, paiement via NathBank, commandes, panel admin avec import JSON.
- **NathNotes** (nathnotes/) : notes, dossiers, favoris, corbeille (suppression logicielle), cookie httpOnly, rate-limit login.
- **NathChat** (nathchat/) : salons, messages WebSocket, réactions, typage, présence en ligne, création de salons.

Dette technique et correctifs identifiés lors de la lecture du code :

## Décisions d'architecture (résolues)

- **Langue du plan et des messages utilisateur :** français (projet francophone, Bac Pro).
- **Pas de framework frontend :** rester sur HTML/CSS/JS vanilla + sql.js (convention du projet).
- **Pas de commit :** le plan est rédigé uniquement ; l'implémentation sera faite par un agent d'implémentation ultérieur.
- **Pas d'estimation de temps :** conformément aux consignes de planification.
- **Plan file location :** `.kilo/plans/` (répertoire existant du projet).

## Correctifs et améliorations — liste ordonnée

### 1. Sécurité et authentification (priorité haute)

**1.1 NathBank — Routes admin sans protection partielle**
- `POST /api/admin/setup` et `POST /api/admin/login` sont dans `routes/admin.js` mais `adminAuth` n'est utilisé que sur produits/catégories. Le setup est protégé par une clé secrète en dur (`NATHSTORE_ADMIN_2026`), acceptable pour un premier admin, mais les routes de modification/suppression de produit n'ont pas de vérification d'existence du produit avant update/delete.
- **Action :** ajouter une vérification d'existence (404 si produit/catégorie introuvable) sur PUT/DELETE produits et catégories.

**1.2 NathBank — JWT secret en dur**
- `SECRET` et `SECRET_ADMIN` sont en dur dans le code. Pour un projet scolaire c'est acceptable, mais le `.env` existe déjà et contient `GITHUB_TOKEN`.
- **Action :** déplacer les secrets JWT dans `.env` (`JWT_SECRET`, `JWT_SECRET_ADMIN`) avec fallback en dur pour le développement.

**1.3 NathBank — Historique des transactions incomplet**
- `GET /api/transactions/historique` ne retourne que les transactions où `de_compte` = compte connecté. Les dépôts (`vers_compte`) n'apparaissent pas. Le solde affiché sur le dashboard est donc incohérent avec l'historique.
- **Action :** retourner les transactions où `de_compte = ? OR vers_compte = ?`. Au frontend, afficher le signe selon le sens (crédit/débit) et la description.

**1.4 NathBank — Dépôt sans plafond effectif**
- `comptes.js` vérifie `montant > 10000000000000` (erreur, message dit "10 000€" mais le seuil est absurde). Il n'y a pas de plafond réel.
- **Action :** corriger le plafond à 10 000€ par dépôt (ou par jour), cohérent avec le message d'erreur.

### 2. NathBank — Dashboard et paiement (priorité moyenne)

**2.1 Dashboard — total dépensé faux**
- `totalDepense` fait la somme de tous les `montant` de l'historique, mais l'historique ne contient que les débits (voir 1.3). Une fois corrigé, il faut sommer uniquement les transactions de type débit.
- **Action :** filtrer `de_compte = compte.id` pour le total dépensé.

**2.2 Paiement — pas de lien NathStore**
- `paiement.html` est une page isolée. Le flux achat réel passe par NathStore (panier → payer → commandes). Il n'y a pas de retour vers NathStore après paiement.
- **Action :** ajouter une option "payer sur NathStore" ou rediriger vers le panier NathStore après paiement depuis le dashboard.

### 3. NathStore — Panier et commande (priorité moyenne)

**3.1 Panier — incohérence stock/prix**
- Le panier stocke `produit_id` + `quantite`. Si un produit est modifié/supprimé entre l'ajout et le paiement, le prix affiché peut être erroné (prix actuel au lieu du prix au moment de l'ajout).
- **Action :** le panier côté client stocke déjà le prix unitaire au moment de l'ajout (`p.prix`). Côté commande, les items sont enregistrés avec `nom, emoji, prix, quantite` — cohérent. Pas de correction nécessaire, mais documenter.

**3.2 Paiement NathStore — pas de vérification de solde avant affichage**
- Le bouton "payer avec nathbank" est désactivé si pas de token ou panier vide, mais on ne vérifie pas le solde du compte avant d'afficher le modal de paiement.
- **Action :** appeler `GET /api/comptes/solde` avant d'ouvrir le modal de paiement, afficher une alerte si solde insuffisant.

**3.3 Commandes — pas de lien avec le statut de paiement**
- Une commande est créée après `POST /api/transactions/payer`. Si le paiement échoue, la commande n'est pas créée (bon). Mais si la création de commande échoue après un paiement réussi, l'argent est débité sans commande.
- **Action :** pour un projet scolaire, accepter ce risque (pas de transaction distribuée). Ajouter un message d'erreur clair si la création de commande échoue après paiement.

### 4. NathNotes — Fonctionnalités manquantes (priorité moyenne)

**4.1 Corbeille non affichée**
- L'API a `/api/notes/deleted` et `/api/notes/:id/restore`, mais le frontend `showTrash()` affiche un message statique "restaurez une note depuis l'api". Aucun bouton de restauration.
- **Action :** implémenter l'affichage de la corbeille avec bouton "restaurer" par note.

**4.2 Favoris non filtrés correctement**
- `showFavorites()` filtre sur `notes` en mémoire, mais `loadNotes()` ne récupère que les notes non supprimées. Les favoris fonctionnent partiellement.
- **Action :** vérifier que `favorite` est retourné par l'API (oui, `SELECT *`) et que le filtre fonctionne. Tester.

**4.3 Suppression définitive manquante**
- Seulement suppression logicielle. Pas de vidage de corbeille ni suppression définitive.
- **Action :** ajouter `DELETE /api/notes/:id/permanent` (ou purger la corbeille) — optionnel, marqué comme amélioration.

**4.4 Recherche côté client uniquement**
- La recherche filtre `notes` en mémoire. Fonctionnel pour un usage local.
- **Action :** garder l'implémentation actuelle, pas de changement.

### 5. NathChat — Fonctionnalités manquantes (priorité moyenne)

**5.1 Pas de page de login dédiée / authentification défaillante**
- Le frontend appelle `fetch('http://localhost:3000/api/login')` mais la route n'existe pas (NathBank a `/api/auth/login`). Le login NathChat ne fonctionnera donc pas.
- **Action :** corriger l'URL vers `http://localhost:3000/api/auth/login` et adapter le parsing de la réponse (`data.token`, `data.nom`).

**5.2 Pas d'envoi de message par entrée**
- `sendMessage()` est appelé par le bouton. La touche Entrée envoie le message (géré), mais pas avec Shift+Enter pour retour à la ligne (déjà géré).
- **Action :** vérifier que l'envoi par Entrée fonctionne (déjà présent).

**5.3 Pas de suppression/modification de message**
- Un message envoyé ne peut pas être modifié ni supprimé.
- **Action :** ajouter `DELETE /api/messages/:id` et WebSocket `delete_message` — amélioration optionnelle.

**5.4 Pas de salon privé / DM**
- Tous les salons sont publics.
- **Action :** marquées comme amélioration future (hors scope Bac Pro).

### 6. Outils et scripts (priorité basse)

**6.1 `start-all.bat` ne lance pas NathChat**
- Lance Banque (3000) et NathNotes (3001), ouvre 3 frontends. NathChat (3002) absent.
- **Action :** ajouter le lancement de `nathchat/server.js` et l'ouverture de `nathchat/public/index.html`.

**6.2 `seed.js` dépend d'un admin préexistant**
- Le seed tente de se logger en admin avant d'insérer les produits. Si aucun compte admin n'est créé (via `/api/admin/setup` avec la clé secrète), le seed échoue silencieusement.
- **Action :** documenter la procédure : créer l'admin d'abord, puis lancer le seed. Ou rendre le seed autonome (créer l'admin si absent).

**6.3 Scripts `clear-*.js` éparpillés**
- Plusieurs scripts de suppression ciblée. Certains pourraient ne pas fonctionner si la base est verrouillée.
- **Action :** vérifier que chaque `clear-*.js` fonctionne, les consolider ou les documenter.

### 7. Documentation (priorité basse)

**7.1 `ReadMe.md` vide**
- Contient uniquement "Note à moi même : rajouter ici un ReadMe.md".
- **Action :** rédiger un vrai ReadMe (présentation, lancement, structure, identifiants de test).

**7.2 `ADMIN.md` contient des secrets en dur**
- Mots de passe, clés JWT, token GitHub dans un fichier suivi par Git (`.gitignore` ignore `.env` mais pas `ADMIN.md`).
- **Action :** déplacer les secrets vers `.env` (déjà ignoré) et vider `ADMIN.md` des valeurs réelles, garder uniquement la structure.

**7.3 `index.html` à la racine est le portail SNT**
- Déjà bien rempli, fait office de documentation vivante. À maintenir.

### 8. Base de données et persistance (priorité basse)

**8.1 Sauvegarde sql.js à chaque écriture**
- `saveDatabase()` est appelé à chaque `run()` (toute écriture). Pour un usage local monoconnexion, acceptable. Risque de corruption si écriture concurrente.
- **Action :** garder tel quel (monoutilisateur local), ajouter un message de console si l'export échoue.

**8.2 Fichiers `.db` versionnés accidentellement**
- `nathchat/nathchat.db` a été commit (commit 4a90b7c). `.gitignore` ignore `banque/banque.db` et `nathnotes/nathnotes.db` mais pas `nathchat/nathchat.db`.
- **Action :** ajouter `nathchat/nathchat.db` à `.gitignore` et le retirer du suivi Git (`git rm --cached`).

### 9. Tests et qualité (priorité basse)

**9.1 Pas de tests automatisés**
- Aucun fichier de test, pas de script `test` significatif (`echo "Error: no test specified"`).
- **Action :** ajouter un script de test basique (ex. : `node -e` vérifiant que les serveurs démarrent) ou documenter les tests manuels. Marqué comme optionnel.

**9.2 Pas de lint**
- Pas d'ESLint ni de Prettier configurés.
- **Action :** optionnel. Ajouter un `.eslintrc` si le temps le permet.

## Plan de mise en œuvre (ordonné)

### Phase 1 — Correctifs critiques (sécurité + cohérence données)
1. Déplacer les secrets JWT dans `.env` (NathBank).
2. Corriger l'historique des transactions (crédit + débit).
3. Corriger le plafond de dépôt à 10 000€.
4. Ajouter vérification d'existence sur PUT/DELETE produits et catégories.
5. Corriger le login NathChat (URL `/api/auth/login`).

### Phase 2 — Fonctionnalités frontend manquantes
6. Implémenter la corbeille NathNotes avec restauration.
7. Ajouter vérification de solde avant paiement NathStore.
8. Ajouter NathChat à `start-all.bat`.

### Phase 3 — Documentation et nettoyage
9. Rédiger `ReadMe.md`.
10. Sanitiser `ADMIN.md` (retirer les secrets réels).
11. Ajouter `nathchat/nathchat.db` à `.gitignore` et retirer du suivi.
12. Documenter la procédure seed (admin d'abord).

### Phase 4 — Améliorations optionnelles (si temps)
13. Suppression définitive de note (NathNotes).
14. Modification/suppression de message (NathChat).
15. Tests manuels documentés.

## Risques

- **sql.js en mémoire + écriture disque à chaque requête** : risque de corruption si deux écritures simultanées. Atténué par l'usage monoconnexion local.
- **JWT secrets en dur** : acceptable pour le projet scolaire, à déplacer dans `.env`.
- **Pas de transaction distribuée entre paiement et commande** : risque de débit sans commande. Acceptable pour le cadre du projet.
- **NathChat dépend de NathBank pour l'auth** : si NathBank est down, NathChat ne peut pas se connecter.

## Validation

Pour chaque correctif, l'agent d'implémentation devra :
1. Démarrer les serveurs (`start-all.bat` ou manuellement).
2. Tester le scénario concerné manuellement dans le navigateur.
3. Vérifier qu'aucune régression n'apparaît sur les autres modules.
4. Confirmer que `git status` ne montre que les fichiers intentés.

## Questions ouvertes (à résoudre avant implémentation)

1. Faut-il implémenter la suppression définitive des notes (NathNotes) ou la corbeille suffit-elle pour le Bac Pro ?
2. Faut-il ajouter ESLint/Prettier ou le projet reste-t-il sans outil de lint ?
3. Le token GitHub dans `.env` doit-il être remplacé par un placeholder avant tout commit ?

---
*Plan rédigé par Kilo (agent de planification). Aucune modification de code source n'a été effectuée. L'implémentation doit être confiée à un agent d'implémentation capable de modifier des fichiers et d'exécuter des commandes.*