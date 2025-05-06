module Web.View.Static.Home where
import Web.View.Prelude

data HomeView = HomeView

instance View HomeView where
    html HomeView = [hsx|
        <div class="home-page">
            {header}
            {heroSection}
            {partnersSection}
        </div>
        <style>
            :root {
                --primary-color: #007BFF;
                --text-color: #333;
                --bg-color: #ffffff;
                --secondary-bg: #f8f9fa;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                color: var(--text-color);
                background: linear-gradient(135deg, #ffffff 50%, #f0f0f0 50%);
                overflow-x: hidden;
            }
            
            .container {
                width: 90%;
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 15px;
            }
            
            /* Header Styles */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 0;
            }
            
            .logo {
                display: flex;
                align-items: center;
            }
            
            .logo-text {
                font-size: 24px;
                font-weight: bold;
                color: #333;
                position: relative;
            }
            
            .logo-text::before {
                content: "";
                display: inline-block;
                width: 30px;
                height: 24px;
                margin-right: 8px;
                background: linear-gradient(135deg, #FF5E62, #FF9966);
                clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
            }
            
            nav ul {
                display: flex;
                list-style: none;
                margin: 0;
                padding: 0;
                gap: 30px;
            }
            
            nav a {
                text-decoration: none;
                color: var(--text-color);
                font-weight: 500;
                transition: color 0.3s;
            }
            
            nav a:hover {
                color: var(--primary-color);
            }
            
            .btn-primary {
                background-color: var(--primary-color);
                color: white;
                padding: 10px 20px;
                border-radius: 50px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s;
                display: inline-block;
                text-transform: uppercase;
                font-size: 14px;
            }
            
            .btn-primary:hover {
                background-color: #0069d9;
            }
            
            /* Hero Section Styles */
            .hero {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 50px;
                align-items: center;
                padding: 60px 0;
                position: relative;
                overflow: hidden;
            }
            
            .hero-content {
                padding-right: 20px;
            }
            
            .hero h1 {
                font-size: 48px;
                line-height: 1.2;
                margin-bottom: 30px;
                color: #333;
                font-weight: bold;
            }
            
            .hero-image {
                position: relative;
                height: 400px;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="500" height="400" viewBox="0 0 500 400"><g fill="none" stroke="%23ccc"></g></svg>');
                background-repeat: no-repeat;
                background-position: center;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            
            /* Puzzle pieces animation */
            .puzzle-container {
                position: relative;
                width: 300px;
                height: 300px;
            }
            
            .puzzle-piece {
                position: absolute;
                width: 100px;
                height: 100px;
                border-radius: 15px;
            }
            
            .piece1 {
                background: linear-gradient(135deg, #FF9966, #FF5E62);
                top: 50px;
                left: 0;
            }
            
            .piece2 {
                background: linear-gradient(135deg, #36D1DC, #5B86E5);
                top: 0;
                left: 100px;
            }
            
            .piece3 {
                background: linear-gradient(135deg, #FF5E62, #FF9966);
                top: 100px;
                left: 100px;
            }
            
            .piece4 {
                background: linear-gradient(135deg, #5B86E5, #36D1DC);
                top: 50px;
                left: 200px;
            }
            
            .hand {
                position: absolute;
                width: 80px;
                height: 80px;
                background-color: #f5d6c1;
                border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
                transform: rotate(45deg);
            }
            
            .hand-1 {
                top: -20px;
                right: 40px;
            }
            
            .hand-2 {
                bottom: 0;
                left: 30px;
            }
            
            .hand-3 {
                bottom: 50px;
                right: 0;
            }
            
            /* Partners Section Styles */
            .partners-section {
                background-color: #f0f0f0;
                padding: 40px 0;
                margin-top: 60px;
            }
            
            .partners {
                display: flex;
                justify-content: space-around;
                align-items: center;
                flex-wrap: wrap;
                gap: 30px;
            }
            
            .partner {
                height: 60px;
                max-width: 200px;
                opacity: 0.7;
                filter: grayscale(100%);
                transition: all 0.3s;
            }
            
            .partner:hover {
                opacity: 1;
                filter: grayscale(0);
            }
            
            .partner1 {
                /* bliss logo placeholder */
                background-color: #f0f0f0;
                width: 100px;
            }
            
            .partner2 {
                /* LARQ logo placeholder */
                background-color: #f0f0f0;
                width: 150px;
            }
            
            .partner3 {
                /* Universidad Mayor logo placeholder */
                background-color: #f0f0f0;
                width: 180px;
            }
            
            .partner4 {
                /* Facultad logo placeholder */
                background-color: #f0f0f0;
                width: 200px;
            }
            
            /* Responsive Styles */
            @media (max-width: 991px) {
                .hero {
                    grid-template-columns: 1fr;
                    text-align: center;
                }
                
                .hero h1 {
                    font-size: 36px;
                }
                
                header {
                    flex-direction: column;
                    gap: 20px;
                }
                
                nav ul {
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 15px;
                }
            }
            
            @media (max-width: 767px) {
                .hero h1 {
                    font-size: 30px;
                }
                
                .partners {
                    gap: 20px;
                }
            }
        </style>
    |]
        where
            header = [hsx|
                <header class="container">
                    <div class="logo">
                        <div class="logo-text">QuizzZite</div>
                    </div>
                    
                    <nav>
                        <ul>
                            <li><a href="#">About</a></li>
                            <li><a href="#">Features</a></li>
                            <li><a href="#">Pricing</a></li>
                            <li class="dropdown">
                                <a href="#">Gallery ▾</a>
                            </li>
                            <li><a href="#">Team</a></li>
                        </ul>
                    </nav>
                    
                    <a href="#" class="btn-primary">INICIAR PRUEBA</a>
                </header>
            |]
            
            heroSection = [hsx|
                <section class="hero container">
                    <div class="hero-content">
                        <h1>Aprender nunca fue tan divertido: ¡resuelve, piensa y arma el conocimiento!"</h1>
                        <a href="#" class="btn-primary">CREA UNA PREGUNTA</a>
                    </div>
                    
                    <div class="hero-image">
                        <div class="puzzle-container">
                            <div class="puzzle-piece piece1"></div>
                            <div class="puzzle-piece piece2"></div>
                            <div class="puzzle-piece piece3"></div>
                            <div class="puzzle-piece piece4"></div>
                            <div class="hand hand-1"></div>
                            <div class="hand hand-2"></div>
                            <div class="hand hand-3"></div>
                        </div>
                    </div>
                </section>
            |]
            
            partnersSection = [hsx|
                <section class="partners-section">
                    <div class="container">
                        <div class="partners">
                            <div class="partner partner1">
                                <!-- bliss logo placeholder -->
                                <svg width="100" height="60" viewBox="0 0 100 60">
                                    <rect width="100" height="60" fill="#f0f0f0" opacity="0.5"/>
                                    <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#888">bliss</text>
                                </svg>
                            </div>
                            <div class="partner partner2">
                                <!-- LARQ logo placeholder -->
                                <svg width="150" height="60" viewBox="0 0 150 60">
                                    <rect width="150" height="60" fill="#f0f0f0" opacity="0.5"/>
                                    <text x="75" y="35" font-family="Arial" font-size="18" text-anchor="middle" fill="#888">LARQ</text>
                                </svg>
                            </div>
                            <div class="partner partner3">
                                <!-- Universidad Mayor logo placeholder -->
                                <svg width="180" height="60" viewBox="0 0 180 60">
                                    <rect width="180" height="60" fill="#f0f0f0" opacity="0.5"/>
                                    <text x="90" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="#888">UNIVERSIDAD</text>
                                    <text x="90" y="45" font-family="Arial" font-size="10" text-anchor="middle" fill="#888">MAYOR DE SAN SIMÓN</text>
                                </svg>
                            </div>
                            <div class="partner partner4">
                                <!-- Facultad logo placeholder -->
                                <svg width="200" height="60" viewBox="0 0 200 60">
                                    <rect width="200" height="60" fill="#f0f0f0" opacity="0.5"/>
                                    <text x="100" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="#888">FACULTAD DE CIENCIAS</text>
                                    <text x="100" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="#888">Y TECNOLOGÍA</text>
                                </svg>
                            </div>
                        </div>
                    </div>
                </section>
            |]