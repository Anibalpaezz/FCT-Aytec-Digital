

export default function AboutUs() {
     return (
          <div className="container">
               <nav className="navbar">
                    <h1>Stock & Stir</h1>
                    <ul>
                         <li><a href="#home">Home</a></li>
                         <li><a href="#contact">Productos</a></li>
                         <li><a href="#about">Recetas y menus</a></li>
                         <li><a href="#contact">Contact</a></li>
                    </ul>
               </nav>
               <main className="content">
                    <h2>Welcome to the About Us Page</h2>
                    <p>This is the About Us page of our awesome app!</p>
                    <button onClick={() => alert('Button clicked!')}>Click Me</button>
               </main>
               <footer className="footer">
                    <p>&copy; 2024 Fleur de Lis S.L. Todos los derechos reservados</p>
               </footer>
          </div>
     );
}
