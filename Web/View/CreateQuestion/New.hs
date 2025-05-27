module Web.View.CreateQuestion.New where

import Web.View.Prelude
import Web.View.Components.Navigation (renderNavigation)

data NewView = NewView

instance View NewView where
    html NewView = [hsx|
        <head>
            <link rel="stylesheet" href="/css/create-question.css" />
            <title>Crea tu Puzzle Educativo - QuizZZite</title>
        </head>
        <body>
            <div class="main-container">
                {renderNavigation}
                
                <div class="content-container">
                    <div class="create-puzzle-container">
                        <div class="page-header">
                            <a href="/" class="back-link">
                                <span class="back-arrow">←</span>
                            </a>
                            <h1 class="page-title">Crea tu Puzzle Educativo</h1>
                            <div class="step-indicator">
                                <span class="step active">1</span>
                                <span class="step">2</span>
                                <span class="step">3</span>
                            </div>
                        </div>
                        
                        <div class="create-puzzle-content">
                            <div class="puzzle-step-container">
                                <div class="puzzle-image-preview">
                                    <div class="shapes-container">
                                        <div class="shape triangle"></div>
                                        <div class="shape square"></div>
                                        <div class="shape circle"></div>
                                    </div>
                                </div>
                                
                                <div class="puzzle-step-instructions">
                                    <h2 class="step-title">Paso 1: Define la pregunta y el nivel de dificultad</h2>
                                    <p class="instructions-label">Instrucciones</p>
                                    <p class="instructions-text">
                                        Este es el primer paso para crear tu puzzle educativo. Aquí debes elegir la 
                                        dificultad (fácil, media o difícil) y definir una pregunta que estará relacionada con 
                                        el contenido visual del puzzle. La pregunta servirá como una guía o reto adicional 
                                        que estimule el pensamiento crítico mientras se arma la imagen.
                                    </p>
                                    <p class="instructions-text">
                                        Nuestra aplicación está diseñada en tres pasos simples. En este primer paso 
                                        defines la base del contenido. Luego, en el segundo paso, podrás subir la imagen 
                                        que se convertirá en el puzzle y escribir una pista para ayudar al jugador.
                                    </p>
                                </div>
                            </div>
                            
                            <form id="step1-form" class="form-container">
                                <div class="form-group">
                                    <label for="question" class="form-label">¿Cuál será la pregunta a resolver?</label>
                                    <input 
                                        type="text" 
                                        id="question" 
                                        name="question" 
                                        placeholder="Ingresa tu pregunta educativa" 
                                        class="form-input" 
                                        required 
                                    />
                                    <div class="input-feedback" id="question-feedback"></div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Establece el nivel de dificultad del puzzle</label>
                                    <div class="difficulty-slider-container">
                                        <span class="difficulty-label">Fácil</span>
                                        <input 
                                            type="range" 
                                            min="1" 
                                            max="3" 
                                            value="1" 
                                            class="difficulty-slider" 
                                            id="difficulty" 
                                            name="difficulty" 
                                        />
                                        <span class="difficulty-label">Difícil</span>
                                    </div>
                                    <div class="difficulty-labels">
                                        <span class="difficulty-level" id="level-1">Fácil</span>
                                        <span class="difficulty-level" id="level-2">Medio</span>
                                        <span class="difficulty-level" id="level-3">Difícil</span>
                                    </div>
                                    <div class="difficulty-description">
                                        <p id="difficulty-desc">Perfecto para principiantes - Menos piezas, formas más simples</p>
                                    </div>
                                </div>
                                
                                <div class="form-actions">
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
                    const form = document.getElementById('step1-form');
                    const questionInput = document.getElementById('question');
                    const difficultySlider = document.getElementById('difficulty');
                    const nextBtn = document.getElementById('next-btn');
                    const questionFeedback = document.getElementById('question-feedback');
                    const difficultyDesc = document.getElementById('difficulty-desc');
                    
                    const difficultyDescriptions = {
                        1: 'Perfecto para principiantes - Menos piezas, formas más simples',
                        2: 'Nivel intermedio - Más piezas, mayor complejidad',
                        3: 'Desafío avanzado - Muchas piezas, máxima dificultad'
                    };
                    
                    // Cargar datos guardados si existen
                    const savedQuestion = sessionStorage.getItem('puzzleQuestion');
                    const savedDifficulty = sessionStorage.getItem('puzzleDifficulty');
                    
                    if (savedQuestion) {
                        questionInput.value = savedQuestion;
                        validateForm();
                    }
                    
                    if (savedDifficulty) {
                        difficultySlider.value = savedDifficulty;
                        updateDifficultyDisplay();
                    }
                    
                    // Validación en tiempo real
                    questionInput.addEventListener('input', function() {
                        validateForm();
                        saveProgress();
                    });
                    
                    difficultySlider.addEventListener('input', function() {
                        updateDifficultyDisplay();
                        saveProgress();
                    });
                    
                    function validateForm() {
                        const questionValue = questionInput.value.trim();
                        
                        if (questionValue.length < 10) {
                            questionFeedback.textContent = 'La pregunta debe tener al menos 10 caracteres';
                            questionFeedback.className = 'input-feedback error';
                            nextBtn.disabled = true;
                        } else if (questionValue.length > 200) {
                            questionFeedback.textContent = 'La pregunta es demasiado larga (máximo 200 caracteres)';
                            questionFeedback.className = 'input-feedback error';
                            nextBtn.disabled = true;
                        } else {
                            questionFeedback.textContent = '✓ Pregunta válida';
                            questionFeedback.className = 'input-feedback success';
                            nextBtn.disabled = false;
                        }
                    }
                    
                    function updateDifficultyDisplay() {
                        const level = difficultySlider.value;
                        difficultyDesc.textContent = difficultyDescriptions[level];
                        
                        // Actualizar indicadores visuales
                        document.querySelectorAll('.difficulty-level').forEach((el, index) => {
                            if (index + 1 <= level) {
                                el.classList.add('active');
                            } else {
                                el.classList.remove('active');
                            }
                        });
                    }
                    
                    function saveProgress() {
                        sessionStorage.setItem('puzzleQuestion', questionInput.value);
                        sessionStorage.setItem('puzzleDifficulty', difficultySlider.value);
                    }
                    
                    // Manejar envío del formulario
                    form.addEventListener('submit', function(e) {
                        e.preventDefault();
                        
                        if (!nextBtn.disabled) {
                            saveProgress();
                            // Redireccionar al paso 2
                            window.location.href = '/NewCuestiontwo';
                        }
                    });
                    
                    // Inicializar display
                    updateDifficultyDisplay();
                });
            </script>
        </body>
    |]