// script.js
document.addEventListener('DOMContentLoaded', () => {
    const nuiContainer = document.getElementById('nui-container');
    const cardStack = document.getElementById('card-stack');
    let missions = [];
    let currentIndex = 0;
    let useLevelSystem = false;
    const resourceName = 'btc-legendaryhunting'; // Nome do recurso atualizado

    function createLevelStarsHTML(level) {
        if (typeof level !== 'number' || level < 0 || level > 5) {
            return '';
        }
        let starsHTML = '<div class="card-level-container">';
        for (let i = 1; i <= 5; i++) {
            if (i <= level) {
                starsHTML += '<span class="star">★</span>';
            } else {
                // starsHTML += '<span class="star empty">☆</span>'; 
            }
        }
        starsHTML += '</div>';
        return starsHTML;
    }

    function createCardElement(mission, index, cardType) {
        const card = document.createElement('div');
        card.classList.add('mission-card', cardType);
        card.dataset.missionIndex = index; // Este índice será do array ordenado
        card.dataset.value = mission.value;

        let levelStarsHTML = '';
        if (useLevelSystem && mission.level !== undefined) {
            levelStarsHTML = createLevelStarsHTML(mission.level);
        }

        card.innerHTML = `
            <h2 class="card-title">${mission.label}</h2>
            <div class="card-image-container">
                <img src="./images/${mission.value}.png" alt="[Imagem de ${mission.label}]" class="card-image" 
                     onerror="this.onerror=null; this.src='https://placehold.co/300x190/7a5a32/f5e8c8?text=Imagem+Indisponivel&font=Roboto+Slab'; this.alt='Imagem indisponível';">
            </div>
            ${levelStarsHTML}
            <p class="card-desc">${mission.desc}</p>
            <button class="accept-mission-btn" style="display: ${cardType === 'current' ? 'block' : 'none'};">ACEITAR MISSÃO</button>
        `;

        const acceptButton = card.querySelector('.accept-mission-btn');
        if (cardType === 'current' && acceptButton) {
            acceptButton.addEventListener('click', (e) => {
                e.stopPropagation();
                acceptMissionCallback(mission.value);
            });
        } else if (cardType === 'next') {
            card.addEventListener('click', (e) => {
                e.stopPropagation();
                advanceToNextCard();
            });
        }
        return card;
    }

    function renderCards() {
        cardStack.innerHTML = ''; 

        if (!missions || missions.length === 0) {
            cardStack.innerHTML = '<p class="no-missions-message">Nenhuma missão disponível.</p>';
            return;
        }

        const numMissions = missions.length;

        const currentMissionData = missions[currentIndex];
        const currentCardEl = createCardElement(currentMissionData, currentIndex, 'current');
        cardStack.appendChild(currentCardEl);

        if (numMissions > 1) {
            const nextIdx = (currentIndex + 1) % numMissions;
            const nextMissionData = missions[nextIdx];
            const nextCardEl = createCardElement(nextMissionData, nextIdx, 'next');
            cardStack.appendChild(nextCardEl);
        }

        if (numMissions > 2) {
            const afterNextIdx = (currentIndex + 2) % numMissions;
             if (afterNextIdx !== currentIndex && afterNextIdx !== (currentIndex + 1) % numMissions) {
                const afterNextMissionData = missions[afterNextIdx];
                const afterNextCardEl = createCardElement(afterNextMissionData, afterNextIdx, 'after-next');
                cardStack.appendChild(afterNextCardEl);
            }
        }
    }

    function advanceToNextCard() {
        if (missions.length <= 1) return; 

        const oldCurrentCard = cardStack.querySelector('.mission-card.current');
        if (oldCurrentCard) {
            oldCurrentCard.classList.remove('current');
            oldCurrentCard.classList.add('animate-out-previous');
        }

        currentIndex = (currentIndex + 1) % missions.length;

        setTimeout(() => {
            const cardToRemove = cardStack.querySelector('.animate-out-previous');
            if (cardToRemove) {
                cardToRemove.remove(); 
            }
            renderCards(); 
        }, 500);
    }

    async function acceptMissionCallback(missionValue) {
        try {
            const resp = await fetch(`https://${resourceName}/acceptMission`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ missionValue: missionValue }) 
            });
        } catch (error) {
            console.error('Erro ao enviar "acceptMission" para o script RedM:', error);
        }
        closeNuiInternal(); 
    }

    function closeNuiInternal() {
        nuiContainer.style.display = 'none'; 
        document.removeEventListener('keydown', handleEscKey); 
    }

    async function closeNuiViaEscCallback() {
        try {
            await fetch(`https://${resourceName}/closeNui`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({}) 
            });
        } catch (error) {
            console.error('Erro ao enviar "closeNui" para o script RedM:', error);
        }
        closeNuiInternal(); 
    }

    function handleEscKey(event) {
        if (event.key === 'Escape') {
            closeNuiViaEscCallback();
        }
    }

    window.addEventListener('message', function(event) {
        const action = event.data.action; 
        const data = event.data; 

        if (action === 'showNUI') {
            missions = data.missions || []; 
            useLevelSystem = data.useLevelSystem === true; 

            // Ordena as missões
            missions.sort((a, b) => {
                const aHasValidLevel = useLevelSystem && typeof a.level === 'number';
                const bHasValidLevel = useLevelSystem && typeof b.level === 'number';

                if (aHasValidLevel && bHasValidLevel) {
                    // Ambas têm níveis válidos, ordena por nível primeiro
                    if (a.level !== b.level) {
                        return a.level - b.level; // Ascendente (menor para maior)
                    }
                    // Níveis são iguais, então ordena por label alfabeticamente
                    return a.label.localeCompare(b.label);
                } else if (aHasValidLevel && !bHasValidLevel) {
                    // 'a' tem nível, 'b' não. 'a' vem primeiro.
                    return -1;
                } else if (!aHasValidLevel && bHasValidLevel) {
                    // 'b' tem nível, 'a' não. 'b' vem primeiro.
                    return 1;
                } else {
                    // Nenhuma tem nível válido (ou useLevelSystem é false)
                    // Ordena por label alfabeticamente
                    return a.label.localeCompare(b.label);
                }
            });
            
            currentIndex = 0; 
            renderCards(); 
            nuiContainer.style.display = 'flex';
            document.addEventListener('keydown', handleEscKey); 
        } else if (action === 'hideNUI') {
            closeNuiInternal(); 
        }
    });

    // function runTestData() {
    //     const mockMissions = [
    //         // Missões de teste com 'value' atualizado e diferentes níveis/labels para testar a ordenação
    //         { label: "Urso lendário", value: "bear", level: 1, desc: "Um boticário local precisa de ervas raras encontradas apenas em locais perigosos. Missão para iniciantes."},
    //         { label: "JAVALI GIGANTE LENDÁRIO", value: "Boar", level: 2, desc: "Um veado com uma galhada impressionante foi avistado nas colinas. Sua pele é extremamente valiosa para artesãos." },
    //         { label: "Caçar Javali Feroz", value: "Bison", level: 3, desc: "Um javali de presas longas aterroriza a plantação local. A recompensa é alta e os fazendeiros agradecem." },
    //         { label: "Procurar Puma Sorrateiro", value: "cougar_sly", level: 4, desc: "Um puma astuto tem sido visto rondando acampamentos abandonados em Roanoke Ridge. Encontre-o antes que cause mais problemas." },
    //         { label: "Coletar Couro de Urso Pardo", value: "bear_brown_pelt", level: 4, desc: "Um caçador renomado precisa de couro de urso pardo de alta qualidade para um cliente exigente em Saint Denis." }, // Mesmo nível, ordem alfabética deve desempatar
    //         { label: "Urso Agressivo", value: "Bear", level: 5, desc: "Um Urso esta atacando pessoas da região! De um jeito nele." },
    //         { label: "Animal Misterioso (Sem Nível)", value: "mystery_animal", desc: "Um animal desconhecido foi avistado. Investigue com cautela."} // Missão sem nível para testar
    //     ];
    //     window.postMessage({ action: 'showNUI', missions: mockMissions, useLevelSystem: true }, '*'); 
    // }
    // runTestData(); // Descomente para testar no navegador
});
