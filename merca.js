const axios = require('axios');
const fs = require('fs');

// Función para obtener categorías
async function getCategories() {
     try {
          const response = await axios.get('https://tienda.mercadona.es/api/categories/');
          const categorias = response.data;

          if (categorias.results) {
               let allCategories = [];
               for (const category of categorias.results) {
                    allCategories.push({ id: category.id, name: category.name });
               }

               // Ordenar todas las categorías por ID
               allCategories.sort((a, b) => a.id - b.id);

               // Construir la salida ordenada
               let output = '';
               for (const category of allCategories) {
                    output += `ID ${category.id}: ${category.name}\n`;
               }

               fs.writeFileSync('productos.txt', output, 'utf8');
               console.log('Resultados guardados en productos.txt');
          }
     } catch (error) {
          console.error('Error fetching categories:', error);
     }
}

// Iniciamos la obtención de categorías
getCategories();
