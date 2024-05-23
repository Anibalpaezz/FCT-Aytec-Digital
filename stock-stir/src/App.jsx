import './App.css';
import Signup from './pages/Signup';
import Home from './pages/Home';
import NotFound from './pages/NotFound';

import { Routes, Route } from 'react-router-dom';

function App() {
     return (
          <div className="App">
               <Routes>
                    <Route path="/" element={<Home />} />
                    <Route path="/Signup" element={<Signup />} />
                    <Route path="*" element={<NotFound />} />
               </Routes>
          </div>
     );
}

export default App;
