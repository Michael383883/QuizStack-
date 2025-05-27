

module Web.View.CreateQuestiontwo.NewCuestiontwo where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data NewCuestiontwoView = NewCuestiontwoView

instance View NewCuestiontwoView where
    html NewCuestiontwoView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/create-questiontwo.css" />
            <title>Sube Imagen y Escribe la Pista - QuizZZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}

                <div class="content-container">
                    <div class="create-puzzle-container">
                        <div class="page-header">
                            <a href="/CreateQuestion/New" class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Sube tu Imagen y Escribe la Pista</h1>
                            <div class="step-indicator">
                                <span class="step completed">1</span>
                                <span class="step active">2</span>
                                <span class="step">3</span>
                            </div>
                        </div>

                        <div class="create-puzzle-content">
                            <div class="puzzle-step-container">
                                <div class="puzzle-image-preview">
                                    <div class="preview-container" id="image-preview-container">
                                        <div class="shapes-container" id="default-shapes">
                                            <div class="shape triangle"></div>
                                            <div class="shape square"></div>
                                            <div class="shape circle"></div>
                                        </div>
                                        <img id="uploaded-image-preview" src="" alt="Vista previa" style="display: none;" />
                                    </div>
                                </div>

                                <div class="puzzle-step-instructions">
                                    <h2 class="step-title">Paso 2: Imagen del Puzzle y Pista de Ayuda</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Selecciona una imagen clara y de buena calidad que esté relacionada con tu pregunta: 
                                        "<span id="current-question">Tu pregunta del paso anterior</span>". 
                                        Luego, escribe una pista que oriente al jugador sin revelar completamente la respuesta.
                                    </p>
                                    <div class="difficulty-reminder">
                                        <span class="difficulty-label">Dificultad seleccionada:</span>
                                        <span id="current-difficulty" class="difficulty-value">Fácil</span>
                                    </div>
                                </div>
                            </div>

                            <form id="step2-form" class="form-container">
                                <div class="form-group">
                                    <label for="hint" class="form-label">¿Cuál será la pista que ayudará a resolver el puzzle?</label>
                                    <textarea 
                                        id="hint" 
                                        name="hint" 
                                        placeholder="Escribe una pista útil pero no demasiado obvia..." 
                                        class="form-textarea"
                                        maxlength="150"
                                    ></textarea>
                                    <div class="char-counter">
                                        <span id="hint-counter">0</span>/150 caracteres
                                    </div>
                                    
                                    <div class="hint-toggle-container">
                                        <label class="switch">
                                            <input type="checkbox" id="no-hint" name="noHint">
                                            <span class="slider round"></span>
                                        </label>
                                        <span class="hint-toggle-label">No incluir pista (puzzle más difícil)</span>
                                    </div>
                                </div>

                                <div class="form-group image-upload-container">
                                    <label class="form-label">Sube la imagen para tu puzzle</label>
                                    <div class="upload-area" id="upload-area">
                                        <div class="upload-content" id="upload-content">
                                            <div class="upload-icon">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                    <polyline points="17 8 12 3 7 8"></polyline>
                                                    <line x1="12" y1="3" x2="12" y2="15"></line>
                                                </svg>
                                            </div>
                                            <p class="upload-text">Arrastra una imagen aquí o haz clic para seleccionar</p>
                                            <p class="upload-format">Formatos JPEG, PNG, WebP • Máximo 10 MB</p>

                                            <div class="upload-button-container">
                                                <label for="file-upload" class="upload-button">
                                                    Seleccionar Archivo
                                                    <input id="file-upload" type="file" accept="image/jpeg,image/png,image/webp" hidden />
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="uploaded-file-info" id="file-info" style="display: none;">
                                            <div class="file-preview">
                                                <img id="file-thumbnail" src="" alt="Miniatura" />
                                                <div class="file-details">
                                                    <span class="file-name" id="file-name"></span>
                                                    <span class="file-size" id="file-size"></span>
                                                </div>
                                            </div>
                                            <button type="button" class="remove-file-btn" id="remove-file">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="upload-feedback" id="upload-feedback"></div>
                                </div>

                                <div class="form-actions">
                                    <button type="button" class="back-button" onclick="window.location.href='/CreateQuestion/New'">
                                        ← Paso anterior
                                    </button>
                                    <button type="submit" class="next-button" id="next-btn" disabled>
                                        Siguiente paso
                                        <span class="btn-arrow">→</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const form = document.getElementById('step2-form');
                    const hintTextarea = document.getElementById('hint');
                    const hintCounter = document.getElementById('hint-counter');
                    const noHintCheckbox = document.getElementById('no-hint');
                    const fileUpload = document.getElementById('file-upload');
                    const uploadArea = document.getElementById('upload-area');
                    const uploadContent = document.getElementById('upload-content');
                    const fileInfo = document.getElementById('file-info');
                    const removeFileBtn = document.getElementById('remove-file');
                    const nextBtn = document.getElementById('next-btn');
                    const uploadFeedback = document.getElementById('upload-feedback');
                    
                    let uploadedFile = null;
                    
                    // Cargar datos del paso anterior
                    loadPreviousStepData();
                    
                    // Cargar datos guardados del paso actual
                    loadSavedData();
                    
                    // Event listeners
                    hintTextarea.addEventListener('input', handleHintInput);
                    noHintCheckbox.addEventListener('change', handleNoHintToggle);
                    fileUpload.addEventListener('change', handleFileSelect);
                    removeFileBtn.addEventListener('click', removeFile);
                    
                    // Drag and drop
                    uploadArea.addEventListener('dragover', handleDragOver);
                    uploadArea.addEventListener('dragleave', handleDragLeave);
                    uploadArea.addEventListener('drop', handleDrop);
                    uploadArea.addEventListener('click', () => fileUpload.click());
                    
                    form.addEventListener('submit', handleFormSubmit);
                    
                    function loadPreviousStepData() {
                        const question = sessionStorage.getItem('puzzleQuestion');
                        const difficulty = sessionStorage.getItem('puzzleDifficulty');
                        
                        if (question) {
                            document.getElementById('current-question').textContent = question;
                        }
                        
                        if (difficulty) {
                            const difficultyNames = ['Fácil', 'Medio', 'Difícil'];
                            document.getElementById('current-difficulty').textContent = difficultyNames[difficulty - 1];
                        }
                    }
                    
                    function loadSavedData() {
                        const savedHint = sessionStorage.getItem('puzzleHint');
                        const savedNoHint = sessionStorage.getItem('puzzleNoHint');
                        const savedImageData = sessionStorage.getItem('puzzleImageData');
                        const savedImageName = sessionStorage.getItem('puzzleImageName');
                        
                        if (savedHint) {
                            hintTextarea.value = savedHint;
                            updateHintCounter();
                        }
                        
                        if (savedNoHint === 'true') {
                            noHintCheckbox.checked = true;
                            handleNoHintToggle();
                        }
                        
                        if (savedImageData && savedImageName) {
                            displayUploadedImage(savedImageData, savedImageName, 0);
                        }
                    }
                    
                    function handleHintInput() {
                        updateHintCounter();
                        saveProgress();
                        validateForm();
                    }
                    
                    function updateHintCounter() {
                        const length = hintTextarea.value.length;
                        hintCounter.textContent = length;
                        
                        if (length > 150) {
                            hintCounter.style.color = '#ef4444';
                        } else if (length > 120) {
                            hintCounter.style.color = '#f59e0b';
                        } else {
                            hintCounter.style.color = '#64748b';
                        }
                    }
                    
                    function handleNoHintToggle() {
                        if (noHintCheckbox.checked) {
                            hintTextarea.disabled = true;
                            hintTextarea.style.opacity = '0.5';
                        } else {
                            hintTextarea.disabled = false;
                            hintTextarea.style.opacity = '1';
                        }
                        saveProgress();
                        validateForm();
                    }
                    
                    function handleFileSelect(e) {
                        const file = e.target.files[0];
                        if (file) {
                            processFile(file);
                        }
                    }
                    
                    function handleDragOver(e) {
                        e.preventDefault();
                        uploadArea.classList.add('drag-over');
                    }
                    
                    function handleDragLeave(e) {
                        e.preventDefault();
                        uploadArea.classList.remove('drag-over');
                    }
                    
                    function handleDrop(e) {
                        e.preventDefault();
                        uploadArea.classList.remove('drag-over');
                        
                        const files = e.dataTransfer.files;
                        if (files.length > 0) {
                            processFile(files[0]);
                        }
                    }
                    
                    function processFile(file) {
                        // Validar tipo de archivo
                        if (!file.type.match(/^image\/(jpeg|png|webp)$/)) {
                            showUploadError('Formato no válido. Solo se permiten JPEG, PNG y WebP.');
                            return;
                        }
                        
                        // Validar tamaño
                        if (file.size > 10 * 1024 * 1024) {
                            showUploadError('El archivo es demasiado grande. Máximo 10 MB.');
                            return;
                        }
                        
                        // Leer archivo
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            displayUploadedImage(e.target.result, file.name, file.size);
                            uploadedFile = file;
                            saveProgress();
                            validateForm();
                        };
                        reader.readAsDataURL(file);
                    }
                    
                    function displayUploadedImage(dataUrl, fileName, fileSize) {
                        // Mostrar en preview principal
                        const previewImg = document.getElementById('uploaded-image-preview');
                        const defaultShapes = document.getElementById('default-shapes');
                        
                        previewImg.src = dataUrl;
                        previewImg.style.display = 'block';
                        defaultShapes.style.display = 'none';
                        
                        // Mostrar info del archivo
                        document.getElementById('file-thumbnail').src = dataUrl;
                        document.getElementById('file-name').textContent = fileName;
                        document.getElementById('file-size').textContent = formatFileSize(fileSize);
                        
                        uploadContent.style.display = 'none';
                        fileInfo.style.display = 'flex';
                        
                        clearUploadError();
                    }
                    
                    function removeFile() {
                        uploadedFile = null;
                        
                        // Ocultar preview
                        document.getElementById('uploaded-image-preview').style.display = 'none';
                        document.getElementById('default-shapes').style.display = 'flex';
                        
                        // Mostrar upload area
                        uploadContent.style.display = 'block';
                        fileInfo.style.display = 'none';
                        
                        // Reset input
                        fileUpload.value = '';
                        
                        // Limpiar storage
                        sessionStorage.removeItem('puzzleImageData');
                        sessionStorage.removeItem('puzzleImageName');
                        
                        validateForm();
                    }
                    
                    function showUploadError(message) {
                        uploadFeedback.textContent = message;
                        uploadFeedback.className = 'upload-feedback error';
                        uploadFeedback.style.display = 'block';
                    }
                    
                    function clearUploadError() {
                        uploadFeedback.style.display = 'none';
                    }
                    
                    function formatFileSize(bytes) {
                        if (bytes === 0) return '0 B';
                        const k = 1024;
                        const sizes = ['B', 'KB', 'MB'];
                        const i = Math.floor(Math.log(bytes) / Math.log(k));
                        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
                    }
                    
                    function validateForm() {
                        const hasImage = uploadedFile !== null || sessionStorage.getItem('puzzleImageData');
                        const hasValidHint = noHintCheckbox.checked || (hintTextarea.value.trim().length >= 5 && hintTextarea.value.length <= 150);
                        
                        nextBtn.disabled = !(hasImage && hasValidHint);
                    }
                    
                    function saveProgress() {
                        sessionStorage.setItem('puzzleHint', hintTextarea.value);
                        sessionStorage.setItem('puzzleNoHint', noHintCheckbox.checked);
                        
                        if (uploadedFile) {
                            const reader = new FileReader();
                            reader.onload = function(e) {
                                sessionStorage.setItem('puzzleImageData', e.target.result);
                                sessionStorage.setItem('puzzleImageName', uploadedFile.name);
                            };
                            reader.readAsDataURL(uploadedFile);
                        }
                    }
                    
                    function handleFormSubmit(e) {
                    e.preventDefault();

                    // Validar y guardar datos en sessionStorage
                    sessionStorage.setItem('puzzleHint', hintTextarea.value);
                    sessionStorage.setItem('puzzleNoHint', noHintCheckbox.checked);

                    // Redirigir a la siguiente página directamente
                    window.location.href = '/Previewquestion';
                    }

                    
                    // Validación inicial
                    validateForm();
                });
            </script>
        </body>
    |]