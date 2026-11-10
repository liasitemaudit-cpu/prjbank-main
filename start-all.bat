@echo off
setlocal

echo === LANCEMENT DE L'ECOSYSTEME NATHBANK ===

:: Lancer le serveur Banque (port 3000)
echo [1/2] Demarrage du serveur Banque (port 3000)...
start "Serveur Banque" /min cmd /k "cd /d '%~dp0banque' && node index.js"

:: Attendre 2 secondes
timeout /t 2 /nobreak >nul

:: Lancer le serveur NathNotes (port 3001)
echo [2/3] Demarrage du serveur NathNotes (port 3001)...
start "Serveur NathNotes" /min cmd /k "cd /d '%~dp0\nathnotes' && node server.js"

:: Attendre 2 secondes
timeout /t 2 /nobreak >nul

:: Lancer le serveur NathChat (port 3002)
echo [3/3] Demarrage du serveur NathChat (port 3002)...
start "Serveur NathChat" /min cmd /k "cd /d '%~dp0\nathchat' && node server.js"

:: Attendre 2 secondes
timeout /t 2 /nobreak >nul

:: Ouvrir le frontend NathBank dans le navigateur
echo.
echo Ouvverture de NathBank dans le navigateur...
start "" "http://127.0.0.1:5500/banque-frontend"

:: Ouvrir NathStore
start "" "http://127.0.0.1:5500/nathstore"

:: Ouvrir NathNotes
start "" "http://127.0.0.1:5500/nathnotes"

:: Ouvrir NathChat
start "" "http://127.0.0.1:5500/nathchat"

echo.
echo === TOUT EST LANCE ===
echo - NathBank  : http://127.0.0.1:5500/banque-frontend
echo - NathStore : http://127.0.0.1:5500/nathstore
echo - NathNotes : http://127.0.0.1:5500/nathnotes
echo - API Banque : http://localhost:3000
echo - API Notes  : http://localhost:3001
echo - API Chat   : http://localhost:3002
echo.
echo Pour arreter les serveurs, fermez les fenetres noires.