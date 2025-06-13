module Web.View.CreateMapa.MapEditor where
import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data MapEditorView = MapEditorView

instance View MapEditorView where
    html MapEditorView = [hsx|
<link rel="stylesheet" href="/css/MapEditor.css" />
<div class="main-container">
                {renderNavigation}      
<div class="map-editor">
    <div class="toolbar">
        <div class="tool-section">
            <h4>🎨 Herramientas</h4>
            <div class="tool-buttons">
                <button class="tool-btn active" data-tool="empty" title="Vacío">
                    <span class="tool-icon">⬜</span>
                    <span class="tool-label">Vacío</span>
                </button>
                <button class="tool-btn" data-tool="start" title="Inicio">
                    <span class="tool-icon">🚀</span>
                    <span class="tool-label">Inicio</span>
                </button>
                <button class="tool-btn" data-tool="goal" title="Objetivo">
                    <span class="tool-icon">🇧🇴</span>
                    <span class="tool-label">Objetivo</span>
                </button>
                <button class="tool-btn" data-tool="ocean" title="Océano">
                    <span class="tool-icon">🌊</span>
                    <span class="tool-label">Océano</span>
                </button>
                <button class="tool-btn" data-tool="mountain" title="Montaña">
                    <span class="tool-icon">⛰️</span>
                    <span class="tool-label">Montaña</span>
                </button>
            </div>
        </div>
        
        <div class="tool-section">
            <h4>🏛️ Países</h4>
            <div class="country-tools">
                <button class="country-btn" data-country="brasil" data-color="#4CAF50" title="Brasil">
                    <span class="country-color" style="background-color: #4CAF50;"></span>
                    <span class="country-label">Brasil</span>
                </button>
                <button class="country-btn" data-country="peru" data-color="#FF9800" title="Perú">
                    <span class="country-color" style="background-color: #FF9800;"></span>
                    <span class="country-label">Perú</span>
                </button>
                <button class="country-btn" data-country="chile" data-color="#F44336" title="Chile">
                    <span class="country-color" style="background-color: #F44336;"></span>
                    <span class="country-label">Chile</span>
                </button>
                <button class="country-btn" data-country="argentina" data-color="#2196F3" title="Argentina">
                    <span class="country-color" style="background-color: #2196F3;"></span>
                    <span class="country-label">Argentina</span>
                </button>
                <button class="country-btn" data-country="paraguay" data-color="#9C27B0" title="Paraguay">
                    <span class="country-color" style="background-color: #9C27B0;"></span>
                    <span class="country-label">Paraguay</span>
                </button>
                <button class="country-btn" data-country="colombia" data-color="#FFEB3B" title="Colombia">
                    <span class="country-color" style="background-color: #FFEB3B;"></span>
                    <span class="country-label">Colombia</span>
                </button>
                <button class="country-btn" data-country="venezuela" data-color="#FF5722" title="Venezuela">
                    <span class="country-color" style="background-color: #FF5722;"></span>
                    <span class="country-label">Venezuela</span>
                </button>
                <button class="country-btn" data-country="ecuador" data-color="#8BC34A" title="Ecuador">
                    <span class="country-color" style="background-color: #8BC34A;"></span>
                    <span class="country-label">Ecuador</span>
                </button>
            </div>
        </div>
        
        <div class="tool-section">
            <h4>⚙️ Configuración</h4>
            <div class="config-controls">
                <div class="config-item">
                    <label>Ancho:</label>
                    <input type="number" id="mapWidth" value="10" min="5" max="20">
                </div>
                <div class="config-item">
                    <label>Alto:</label>
                    <input type="number" id="mapHeight" value="8" min="5" max="15">
                </div>
                <button class="action-btn" id="resizeMap">📏 Redimensionar</button>
            </div>
        </div>
        
        <div class="tool-section">
            <h4>💾 Acciones</h4>
            <div class="action-controls">
                <button class="action-btn primary" id="generateConfig">🔧 Generar Código</button>
                <button class="action-btn secondary" id="clearMap">🗑️ Limpiar Todo</button>
                <button class="action-btn secondary" id="loadExample">📋 Ejemplo</button>
            </div>
        </div>
    </div>
    <!-- Editor de mapa -->
    <div class="map-editor-container">
        <div class="map-grid-editor" id="mapGridEditor">
        </div>
        
        <!-- Panel de información -->
        <div class="info-panel">
            <div class="current-tool">
                <h4>🛠️ Herramienta Actual</h4>
                <div class="tool-display" id="currentToolDisplay">
                    <span class="tool-icon">⬜</span>
                    <span class="tool-name">Vacío</span>
                </div>
            </div>
            <div class="map-stats">
                <h4>📊 Estadísticas</h4>
                <div class="stat-item">
                    <span>Tamaño: </span>
                    <span id="mapDimensions">10 x 8</span>
                </div>
                <div class="stat-item">
                    <span>Celdas totales: </span>
                    <span id="totalCells">80</span>
                </div>
                <div class="stat-item">
                    <span>Países: </span>
                    <span id="countryCount">0</span>
                </div>
                <div class="stat-item">
                    <span>Obstáculos: </span>
                    <span id="obstacleCount">0</span>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal para mostrar código generado -->
    <div class="modal-overlay" id="codeModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🔧 Configuración Generada</h3>
                <button class="close-btn" id="closeModal">✕</button>
            </div>
            <div class="modal-body">
                <div class="code-section">
                    <h4>JavaScript Configuration:</h4>
                    <textarea id="generatedConfig" readonly></textarea>
                    <button class="copy-btn" id="copyConfig">📋 Copiar</button>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<script>
    // Estado del editor
    let editorState = {
        width: 10,
        height: 8,
        cellSize: 50,
        currentTool: 'empty',
        currentCountry: null,
        currentColor: null,
        map: [], 
        startPos: null,
        goalPos: null
    };
    const CELL_TYPES = {
        empty: { icon: '⬜', label: 'Vacío', color: '#f0f0f0', class: 'empty' },
        start: { icon: '🚀', label: 'Inicio', color: '#00E676', class: 'start' },
        goal: { icon: '🇧🇴', label: 'Objetivo', color: '#FFD600', class: 'goal' },
        ocean: { icon: '🌊', label: 'Océano', color: '#2196F3', class: 'ocean' },
        mountain: { icon: '⛰️', label: 'Montaña', color: '#795548', class: 'mountain' },
        country: { icon: '', label: 'País', color: '', class: 'country' }
    };
    const COUNTRIES = {
        brasil: { name: 'Brasil', code: 'BRA', color: '#4CAF50' },
        peru: { name: 'Perú', code: 'PER', color: '#FF9800' },
        chile: { name: 'Chile', code: 'CHI', color: '#F44336' },
        argentina: { name: 'Argentina', code: 'ARG', color: '#2196F3' },
        paraguay: { name: 'Paraguay', code: 'PAR', color: '#9C27B0' },
        colombia: { name: 'Colombia', code: 'COL', color: '#FFEB3B' },
        venezuela: { name: 'Venezuela', code: 'VEN', color: '#FF5722' },
        ecuador: { name: 'Ecuador', code: 'ECU', color: '#8BC34A' }
    };
    
    const mapGridEditor = document.getElementById('mapGridEditor');
    const currentToolDisplay = document.getElementById('currentToolDisplay');
    const codeModal = document.getElementById('codeModal');
    const generatedConfig = document.getElementById('generatedConfig');
    
    // Inicializar el editor
    function initializeEditor() {
        console.log('🎨 Inicializando editor de mapas...');
        initializeMapMatrix();
        createMapGrid();
        setupEventListeners();
        updateStats();
        
        console.log('✅ Editor inicializado correctamente');
    }
    function initializeMapMatrix() {
        editorState.map = [];
        for (let y = 0; y < editorState.height; y++) {
            editorState.map[y] = [];
            for (let x = 0; x < editorState.width; x++) {
                editorState.map[y][x] = {
                    type: 'empty',
                    country: null,
                    color: null
                };
            }
        }
    }
    
    // Crear el grid visual del mapa
    function createMapGrid() {
        mapGridEditor.innerHTML = '';
        mapGridEditor.style.gridTemplateColumns = `repeat(${editorState.width}, ${editorState.cellSize}px)`;
        mapGridEditor.style.gridTemplateRows = `repeat(${editorState.height}, ${editorState.cellSize}px)`;
        
        for (let y = 0; y < editorState.height; y++) {
            for (let x = 0; x < editorState.width; x++) {
                const cell = document.createElement('div');
                cell.className = 'editor-cell';
                cell.dataset.x = x;
                cell.dataset.y = y;
                const cellContent = document.createElement('div');
                cellContent.className = 'cell-content';
                cell.appendChild(cellContent);
                const coords = document.createElement('div');
                coords.className = 'cell-coords';
                coords.textContent = `${x},${y}`;
                cell.appendChild(coords);
                cell.addEventListener('click', () => editCell(x, y));
                cell.addEventListener('mouseenter', () => highlightCell(x, y));
                cell.addEventListener('mouseleave', () => unhighlightCell(x, y));
                mapGridEditor.appendChild(cell);
                updateCellAppearance(x, y);
            }
        }
    }
    function editCell(x, y) {
        console.log(`🖱️ Editando celda (${x}, ${y}) con herramienta: ${editorState.currentTool}`);
        
        const cellData = editorState.map[y][x];
        if (editorState.currentTool === 'start') {
            // Solo puede haber un punto de inicio
            if (editorState.startPos) {
                const oldStart = editorState.startPos;
                editorState.map[oldStart.y][oldStart.x] = { type: 'empty', country: null, color: null };
                updateCellAppearance(oldStart.x, oldStart.y);
            }
            editorState.startPos = { x, y };
        } else if (editorState.currentTool === 'goal') {
            if (editorState.goalPos) {
                const oldGoal = editorState.goalPos;
                editorState.map[oldGoal.y][oldGoal.x] = { type: 'empty', country: null, color: null };
                updateCellAppearance(oldGoal.x, oldGoal.y);
            }
            editorState.goalPos = { x, y };
        }
    
        if (editorState.currentTool === 'country') {
            cellData.type = 'country';
            cellData.country = editorState.currentCountry;
            cellData.color = editorState.currentColor;
        } else {
            cellData.type = editorState.currentTool;
            cellData.country = null;
            cellData.color = null;
            
            // Limpiar referencias de posición si se elimina
            if (editorState.currentTool === 'empty') {
                if (editorState.startPos && editorState.startPos.x === x && editorState.startPos.y === y) {
                    editorState.startPos = null;
                }
                if (editorState.goalPos && editorState.goalPos.x === x && editorState.goalPos.y === y) {
                    editorState.goalPos = null;
                }
            }
        }
        
        updateCellAppearance(x, y);
        updateStats();
    }

    function updateCellAppearance(x, y) {
        const cell = document.querySelector(`[data-x="${x}"][data-y="${y}"]`);
        const cellContent = cell.querySelector('.cell-content');
        const cellData = editorState.map[y][x];
        cell.className = 'editor-cell';
        if (cellData.type === 'country' && cellData.country) {
            const country = COUNTRIES[cellData.country];
            cell.classList.add('country');
            cell.style.backgroundColor = country.color;
            cellContent.innerHTML = `<span class="country-code">${country.code}</span>`;
            cell.title = country.name;
        } else {
            const cellType = CELL_TYPES[cellData.type];
            cell.classList.add(cellType.class);
            cell.style.backgroundColor = cellType.color;
            cellContent.innerHTML = `<span class="cell-icon">${cellType.icon}</span>`;
            cell.title = cellType.label;
        }
    }
    
    // Resaltar celda al pasar el mouse
    function highlightCell(x, y) {
        const cell = document.querySelector(`[data-x="${x}"][data-y="${y}"]`);
        cell.classList.add('hover');
    }
    
    // Quitar resaltado
    function unhighlightCell(x, y) {
        const cell = document.querySelector(`[data-x="${x}"][data-y="${y}"]`);
        cell.classList.remove('hover');
    }
    
    // Configurar event listeners
    function setupEventListeners() {
        // Herramientas básicas
        document.querySelectorAll('.tool-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                // Limpiar selección anterior
                document.querySelectorAll('.tool-btn').forEach(b => b.classList.remove('active'));
                document.querySelectorAll('.country-btn').forEach(b => b.classList.remove('active'));
                
                // Activar herramienta
                btn.classList.add('active');
                editorState.currentTool = btn.dataset.tool;
                editorState.currentCountry = null;
                editorState.currentColor = null;
                
                updateCurrentToolDisplay();
            });
        });
        
        // Herramientas de países
        document.querySelectorAll('.country-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                // Limpiar selección anterior
                document.querySelectorAll('.tool-btn').forEach(b => b.classList.remove('active'));
                document.querySelectorAll('.country-btn').forEach(b => b.classList.remove('active'));
                
                // Activar país
                btn.classList.add('active');
                editorState.currentTool = 'country';
                editorState.currentCountry = btn.dataset.country;
                editorState.currentColor = btn.dataset.color;
                
                updateCurrentToolDisplay();
            });
        });
        
        // Controles de configuración
        document.getElementById('resizeMap').addEventListener('click', resizeMap);
        document.getElementById('generateConfig').addEventListener('click', generateConfig);
        document.getElementById('clearMap').addEventListener('click', clearMap);
        document.getElementById('loadExample').addEventListener('click', loadExample);
        
        // Modal
        document.getElementById('closeModal').addEventListener('click', closeModal);
        document.getElementById('copyConfig').addEventListener('click', copyConfig);
        
        // Cerrar modal al hacer click fuera
        codeModal.addEventListener('click', (e) => {
            if (e.target === codeModal) closeModal();
        });
    }
    
    // Actualizar display de herramienta actual
    function updateCurrentToolDisplay() {
        const display = currentToolDisplay;
        const iconSpan = display.querySelector('.tool-icon');
        const nameSpan = display.querySelector('.tool-name');
        
        if (editorState.currentTool === 'country' && editorState.currentCountry) {
            const country = COUNTRIES[editorState.currentCountry];
            iconSpan.textContent = country.code;
            iconSpan.style.backgroundColor = country.color;
            iconSpan.style.color = '#fff';
            iconSpan.style.padding = '2px 4px';
            iconSpan.style.borderRadius = '3px';
            nameSpan.textContent = country.name;
        } else {
            const cellType = CELL_TYPES[editorState.currentTool];
            iconSpan.textContent = cellType.icon;
            iconSpan.style.backgroundColor = '';
            iconSpan.style.color = '';
            iconSpan.style.padding = '';
            iconSpan.style.borderRadius = '';
            nameSpan.textContent = cellType.label;
        }
    }
    
    // Redimensionar mapa
    function resizeMap() {
        const newWidth = parseInt(document.getElementById('mapWidth').value);
        const newHeight = parseInt(document.getElementById('mapHeight').value);
        
        if (newWidth < 5 || newWidth > 20 || newHeight < 5 || newHeight > 15) {
            alert('⚠️ Dimensiones inválidas. Ancho: 5-20, Alto: 5-15');
            return;
        }
        
        console.log(`📏 Redimensionando mapa a ${newWidth}x${newHeight}`);
        
        editorState.width = newWidth;
        editorState.height = newHeight;
        
        // Verificar si las posiciones especiales siguen siendo válidas
        if (editorState.startPos && (editorState.startPos.x >= newWidth || editorState.startPos.y >= newHeight)) {
            editorState.startPos = null;
        }
        if (editorState.goalPos && (editorState.goalPos.x >= newWidth || editorState.goalPos.y >= newHeight)) {
            editorState.goalPos = null;
        }
        
        initializeMapMatrix();
        createMapGrid();
        updateStats();
    }
    
    // Limpiar mapa
    function clearMap() {
        if (confirm('🗑️ ¿Estás seguro de que quieres limpiar todo el mapa?')) {
            console.log('🗑️ Limpiando mapa...');
            editorState.startPos = null;
            editorState.goalPos = null;
            initializeMapMatrix();
            createMapGrid();
            updateStats();
        }
    }
    
    // Cargar ejemplo
    function loadExample() {
        console.log('📋 Cargando mapa de ejemplo...');
        
        // Limpiar mapa primero
        initializeMapMatrix();
        
        // Configurar posiciones especiales
        editorState.startPos = { x: 0, y: 0 };
        editorState.goalPos = { x: 4, y: 4 };
        
        // Colocar inicio y objetivo
        editorState.map[0][0] = { type: 'start', country: null, color: null };
        editorState.map[4][4] = { type: 'goal', country: null, color: null };
        
        // Añadir países (ejemplo basado en tu código original)
        const exampleCountries = [
            // Brasil
            { x: 6, y: 1, country: 'brasil' }, { x: 7, y: 1, country: 'brasil' }, { x: 8, y: 1, country: 'brasil' },
            { x: 6, y: 2, country: 'brasil' }, { x: 7, y: 2, country: 'brasil' }, { x: 8, y: 2, country: 'brasil' },
            { x: 5, y: 3, country: 'brasil' }, { x: 6, y: 3, country: 'brasil' }, { x: 7, y: 3, country: 'brasil' },
            // Perú
            { x: 1, y: 3, country: 'peru' }, { x: 2, y: 3, country: 'peru' },
            { x: 1, y: 4, country: 'peru' }, { x: 2, y: 4, country: 'peru' },
            // Argentina
            { x: 3, y: 5, country: 'argentina' }, { x: 4, y: 5, country: 'argentina' },
            { x: 3, y: 6, country: 'argentina' }, { x: 4, y: 6, country: 'argentina' }
        ];
        
        exampleCountries.forEach(({ x, y, country }) => {
            if (y < editorState.height && x < editorState.width) {
                editorState.map[y][x] = {
                    type: 'country',
                    country: country,
                    color: COUNTRIES[country].color
                };
            }
        });
        
        // Añadir océanos
        const exampleOceans = [
            { x: 0, y: 1 }, { x: 0, y: 2 }, { x: 0, y: 3 }, { x: 0, y: 5 }, { x: 0, y: 6 }, { x: 0, y: 7 },
            { x: 9, y: 0 }, { x: 9, y: 1 }, { x: 9, y: 2 }, { x: 9, y: 3 }, { x: 9, y: 4 }, { x: 9, y: 5 }
        ];
        
        exampleOceans.forEach(({ x, y }) => {
            if (y < editorState.height && x < editorState.width) {
                editorState.map[y][x] = { type: 'ocean', country: null, color: null };
            }
        });
        
        // Añadir montañas
        const exampleMountains = [
            { x: 2, y: 1 }, { x: 3, y: 1 }, { x: 2, y: 2 }, { x: 3, y: 2 }
        ];
        
        exampleMountains.forEach(({ x, y }) => {
            if (y < editorState.height && x < editorState.width) {
                editorState.map[y][x] = { type: 'mountain', country: null, color: null };
            }
        });
        
        createMapGrid();
        updateStats();
    }
    
    // Actualizar estadísticas
    function updateStats() {
        document.getElementById('mapDimensions').textContent = `${editorState.width} x ${editorState.height}`;
        document.getElementById('totalCells').textContent = editorState.width * editorState.height;
        
        let countryCount = 0;
        let obstacleCount = 0;
        
        for (let y = 0; y < editorState.height; y++) {
            for (let x = 0; x < editorState.width; x++) {
                const cell = editorState.map[y][x];
                if (cell.type === 'country') countryCount++;
                if (cell.type === 'ocean' || cell.type === 'mountain') obstacleCount++;
            }
        }
        
        document.getElementById('countryCount').textContent = countryCount;
        document.getElementById('obstacleCount').textContent = obstacleCount;
    }
    
    // Generar configuración
    function generateConfig() {
        console.log('🔧 Generando configuración...');
        
        if (!editorState.startPos || !editorState.goalPos) {
            alert('⚠️ Debes colocar un punto de inicio y un objetivo antes de generar la configuración.');
            return;
        }
        
        const config = {
            width: editorState.width,
            height: editorState.height,
            cellSize: 60,
            startPos: editorState.startPos,
            goalPos: editorState.goalPos,
            countries: [],
            oceans: [],
            mountains: []
        };
        
        // Recorrer el mapa y clasificar celdas
        for (let y = 0; y < editorState.height; y++) {
            for (let x = 0; x < editorState.width; x++) {
                const cell = editorState.map[y][x];
                
                switch (cell.type) {
                    case 'country':
                        if (cell.country) {
                            const country = COUNTRIES[cell.country];
                            config.countries.push({
                                x: x,
                                y: y,
                                name: country.name,
                                code: country.code,
                                color: country.color
                            });
                        }
                        break;
                    case 'ocean':
                        config.oceans.push({ x: x, y: y });
                        break;
                    case 'mountain':
                        config.mountains.push({ x: x, y: y });
                        break;
                }
            }
        }
        
        // Generar código JavaScript
        const jsConfig = `const MAP_CONFIG = ${JSON.stringify(config, null, 4)};`;
        
        generatedConfig.value = jsConfig;
        codeModal.classList.add('active');
    }
    
    // Cerrar modal
    function closeModal() {
        codeModal.classList.remove('active');
    }
    
    // Copiar configuración
    function copyConfig() {
        generatedConfig.select();
        document.execCommand('copy');
        
        const copyBtn = document.getElementById('copyConfig');
        const originalText = copyBtn.textContent;
        copyBtn.textContent = '✅ Copiado!';
        setTimeout(() => {
            copyBtn.textContent = originalText;
        }, 2000);
    }
    
    // Inicialización cuando el DOM esté listo
    document.addEventListener('DOMContentLoaded', function() {
        console.log('🎨 MapEditor iniciando...');
        initializeEditor();
        console.log('✅ MapEditor listo para uso');
    });
    
    console.log('🎨 MapEditor módulo cargado');
</script>
|]