module Web.View.PuzzleResolution.MapPreview where
import Web.View.Prelude

renderMapPreview = [hsx|
    <div class="puzzle-tab">
        <h2 class="tab-title">Puzzle en Proceso</h2>
        <div class="puzzle-preview">
            <img src="/images/southamerica-map.png" alt="Mapa de Sudamérica" class="map-image" />
        </div>
        <button class="finalize-button">Finalizar</button>
    </div>
|]