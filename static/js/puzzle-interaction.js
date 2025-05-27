// Estado global del puzzle
let puzzleState = {
    currentPiece: null,
    codeInstructions: [],
    completedPieces: [],
    mapProgress: 0
};

// Cambiar pieza seleccionada
function changePiece(pieceId) {
    puzzleState.currentPiece = parseInt(pieceId);
    updatePiecePreview(pieceId);
    updateAvailableInstructions(pieceId);
}

// Actualizar vista previa de la pieza
function updatePiecePreview(pieceId) {
    // Aquí harías una llamada AJAX a tu controlador
    fetch(`/puzzle/piece/${pieceId}`)
        .then(response => response.json())
        .then(data => {
            document.querySelector('#piece-preview img').src = data.imageUrl;
            document.querySelector('#piece-preview img').alt = data.name;
        });
}

// Agregar instrucción al código
function addInstruction(button) {
    const instruction = button.dataset.instruction;
    const codeContent = document.getElementById('code-content');
    codeContent.value += instruction + '\n';
    puzzleState.codeInstructions.push(instruction);
}

// Construir/Armar la pieza
function buildPuzzle() {
    const code = document.getElementById('code-content').value;
    
    // Enviar código al servidor para validación
    fetch('/puzzle/build', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            pieceId: puzzleState.currentPiece,
            code: code
        })
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            updateMapPreview(result.mapState);
            checkPuzzleCompletion();
        } else {
            showError(result.error);
        }
    });
}

// Actualizar vista del mapa
function updateMapPreview(mapState) {
    const mapImg = document.getElementById('current-map');
    mapImg.src = `/images/maps/${mapState.currentMap}`;
    
    puzzleState.mapProgress = mapState.progress;
    updateProgressBar(mapState.progress);
}

// Actualizar barra de progreso
function updateProgressBar(progress) {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    progressFill.style.width = `${progress * 100}%`;
    progressText.textContent = `${Math.round(progress * 100)}% completado`;
}

// Verificar si el puzzle está completo
function checkPuzzleCompletion() {
    if (puzzleState.mapProgress >= 1.0) {
        const buildButton = document.getElementById('build-button');
        const finalizeButton = document.getElementById('finalize-button');
        
        buildButton.textContent = 'Ejecutar';
        buildButton.onclick = executePuzzle;
        finalizeButton.disabled = false;
    }
}

// Ejecutar puzzle completo
function executePuzzle() {
    fetch('/puzzle/execute', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            puzzleState: puzzleState
        })
    })
    .then(response => response.json()) 
    .then(result => {
        if (result.success) {
            showCompletionAnimation();
            updateFinalMap(result.finalMap);
        } else {
            showExecutionError(result.error);
        }
    })
    .catch(error => {
        console.error('Error al ejecutar el puzzle:', error);
        showExecutionError('Error de red o del servidor');
    });
}


// Finalizar puzzle
function finalizePuzzle() {
   fetch('/puzzle/finalize', {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json',
       },
       body: JSON.stringify({
           puzzleId: puzzleState.puzzleId,
           finalState: puzzleState
       })
   })
   .then(response => response.json())
   .then(result => {
       if (result.success) {
           window.location.href = result.redirectUrl;
       }
   });
}

// Mostrar animación de completación
function showCompletionAnimation() {
   const mapPreview = document.getElementById('map-preview');
   mapPreview.classList.add('completed');
   
   // Agregar efectos visuales
   const celebration = document.createElement('div');
   celebration.className = 'celebration-overlay';
   celebration.innerHTML = '🎉 ¡Puzzle Completado! 🎉';
   mapPreview.appendChild(celebration);
   
   setTimeout(() => {
       celebration.remove();
   }, 3000);
}

// Actualizar mapa final
function updateFinalMap(mapData) {
   const mapImg = document.getElementById('current-map');
   mapImg.src = mapData.finalImageUrl;
   mapImg.classList.add('completed-map');
}

// Mostrar errores
function showError(errorMessage) {
   const errorDiv = document.createElement('div');
   errorDiv.className = 'error-message';
   errorDiv.textContent = errorMessage;
   
   const codeEditor = document.getElementById('code-editor');
   codeEditor.appendChild(errorDiv);
   
   setTimeout(() => {
       errorDiv.remove();
   }, 5000);
}

// Mostrar errores de ejecución
function showExecutionError(errorMessage) {
   const mapPreview = document.querySelector('.puzzle-preview');
   mapPreview.classList.add('error-state');
   
   const errorOverlay = document.createElement('div');
   errorOverlay.className = 'error-overlay';
   errorOverlay.textContent = `Error: ${errorMessage}`;
   mapPreview.appendChild(errorOverlay);
   
   setTimeout(() => {
       errorOverlay.remove();
       mapPreview.classList.remove('error-state');
   }, 4000);
}

// Inicializar cuando se carga la página
document.addEventListener('DOMContentLoaded', function() {
   // Cargar estado inicial del puzzle
   const puzzleId = document.body.dataset.puzzleId;
   if (puzzleId) {
       loadPuzzleState(puzzleId);
   }
});

// Cargar estado del puzzle desde el servidor
function loadPuzzleState(puzzleId) {
   fetch(`/puzzle/state/${puzzleId}`)
       .then(response => response.json())
       .then(data => {
           puzzleState = { ...puzzleState, ...data };
           initializePuzzleUI();
       });
}

// Inicializar interfaz de usuario
function initializePuzzleUI() {
   // Configurar selector de piezas
   const pieceSelector = document.getElementById('piece-selector');
   if (puzzleState.currentPiece) {
       pieceSelector.value = puzzleState.currentPiece;
       changePiece(puzzleState.currentPiece);
   }
   
   // Restaurar código si existe
   if (puzzleState.codeInstructions.length > 0) {
       const codeContent = document.getElementById('code-content');
       codeContent.value = puzzleState.codeInstructions.join('\n');
   }
   
   // Actualizar progreso del mapa
   if (puzzleState.mapProgress > 0) {
       updateProgressBar(puzzleState.mapProgress);
   }
}