module Web.View.MapProcessor.ShowProcessor where

import Web.View.Prelude

data ShowProcessorView = ShowProcessorView

instance View ShowProcessorView where
    html ShowProcessorView = [hsx|
        <div class="map-processor-container">
            <h2>Procesador de Mapas para Rompecabezas</h2>
            
            <form id="map-upload-form" enctype="multipart/form-data">
                <div class="upload-section">
                    <label for="mapImage">Seleccionar imagen del mapa:</label>
                    <input type="file" name="mapImage" id="mapImage" accept="image/*" required/>
                </div>
                
                <div class="map-type-section">
                    <label for="mapType">Tipo de mapa:</label>
                    <select name="mapType" id="mapType">
                        <option value="south_america">Sudamérica</option>
                        <option value="world">Mundo</option>
                        <option value="europe">Europa</option>
                        <option value="north_america">Norteamérica</option>
                    </select>
                </div>
                
                <button type="submit">Procesar Mapa</button>
            </form>
            
            <div id="processing-status" style="display: none;">
                <p>Procesando mapa...</p>
                <div class="progress-bar">
                    <div class="progress" id="progress"></div>
                </div>
            </div>
            
            <div id="result-section" style="display: none;">
                <h3>Mapa Procesado</h3>
                <div id="processed-map-preview"></div>
                <button id="use-map-btn">Usar este mapa para rompecabezas</button>
            </div>
        </div>
        
        <script>
            document.getElementById('map-upload-form').addEventListener('submit', async function(e) {
                e.preventDefault();
                
                const formData = new FormData(this);
                const statusDiv = document.getElementById('processing-status');
                const resultDiv = document.getElementById('result-section');
                
                statusDiv.style.display = 'block';
                resultDiv.style.display = 'none';
                
                try {
                    const response = await fetch('/MapProcessor', {
                        method: 'POST',
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        // Mostrar el mapa procesado
                        document.getElementById('processed-map-preview').innerHTML = 
                            `<iframe src="${result.previewUrl}" width="400" height="500" style="border: 1px solid #ccc;"></iframe>`;
                        
                        document.getElementById('use-map-btn').onclick = function() {
                            // Guardar el ID del mapa en sessionStorage para usar en el creador de puzzles
                            sessionStorage.setItem('selectedMapId', result.mapId);
                            sessionStorage.setItem('puzzleImageData', result.previewUrl);
                            sessionStorage.setItem('puzzleImageName', formData.get('mapImage').name);
                            
                            // Redireccionar al creador de puzzles
                            window.location.href = '/CreateQuestiontwo/New';
                        };
                        
                        statusDiv.style.display = 'none';
                        resultDiv.style.display = 'block';
                    } else {
                        alert('Error procesando el mapa');
                        statusDiv.style.display = 'none';
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('Error procesando el mapa');
                    statusDiv.style.display = 'none';
                }
            });
        </script>
    |]