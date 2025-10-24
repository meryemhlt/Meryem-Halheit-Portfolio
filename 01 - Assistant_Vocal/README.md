# Assistant vocal historique (Python + IA)

## Objectif
Développer un assistant vocal interactif capable de répondre oralement à des questions d’histoire,  
en combinant reconnaissance vocale, recherche automatisée sur Wikipédia et synthèse vocale.

Ce projet illustre la capacité à relier data, API textuelles et nteraction homme-machine,  
dans un cadre simple et pédagogique.

---

## Fonctionnalités principales
- Reconnaissance vocale : le programme écoute la question de l’utilisateur (via micro)
- Recherche de contenu : interroge Wikipédia pour extraire la réponse pertinente
- Synthèse vocale : lit la réponse à voix haute via `pyttsx3`
- Gestion des erreurs (mot incompris, absence de réponse, silence…)

---

## Outils et bibliothèques
- `speech_recognition` — reconnaissance vocale Google API  
- `wikipedia` — recherche et résumé d’article  
- `pyttsx3` — synthèse vocale locale  
- `pyaudio` — interface micro (pour Mac, nécessite `brew install portaudio`)

---

## Structure du notebook
Le notebook `assistant_vocal.ipynb` contient :

1. Initialisation des modules et réglages de voix
2. Fonctions principales:
   - `parler(texte)` — fait parler l’assistant
   - `ecouter()` — capture la voix et la convertit en texte
   - `repondre(question)` — recherche la réponse sur Wikipédia
3. Boucle interactive :  
   - le programme écoute, répond, et s’arrête quand l’utilisateur dit "stop".
   
![Démonstration](demo_assistant.png)

---

