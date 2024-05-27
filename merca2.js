const axios = require('axios');
const fs = require('fs');

// Función para obtener categorías y subcategorías
async function getCategories() {
     try {
          const response = await axios.get('https://tienda.mercadona.es/api/categories/');
          const categorias = response.data;

          if (categorias.results) {
               let allCategories = [];

               for (const category of categorias.results) {
                    let categoryData = { id: category.id, name: category.name, subcategories: [] };

                    // Obtener subcategorías
                    const subcategories = await getCategory(category.id);
                    categoryData.subcategories = subcategories;

                    allCategories.push(categoryData);
               }

               // Ordenar todas las categorías y subcategorías por ID
               allCategories.sort((a, b) => a.id - b.id);

               // Construir la salida ordenada
               let output = '';
               for (const category of allCategories) {
                    output += `ID ${category.id}: ${category.name}\n`;

                    // Ordenar subcategorías
                    category.subcategories.sort((a, b) => a.id - b.id);
                    for (const subcategory of category.subcategories) {
                         output += `  Subcategoría ID ${subcategory.id}: ${subcategory.name}\n`;
                    }
               }

               fs.writeFileSync('productos2.txt', output, 'utf8');
               console.log('Resultados guardados en productos2.txt');
          }
     } catch (error) {
          console.error('Error fetching categories:', error);
     }
}

// Función para obtener una categoría específica y sus subcategorías
async function getCategory(categoryId) {
     try {
          const response = await axios.get(`https://tienda.mercadona.es/api/categories/${categoryId}`);
          const category = response.data;

          let subcategories = [];
          if (category.categories) {
               for (const catInfo of category.categories) {
                    subcategories.push({ id: catInfo.id, name: catInfo.name });
               }
          }
          return subcategories;
     } catch (error) {
          console.error(`Error fetching category ${categoryId}:`, error);
          return [];
     }
}

// Iniciamos la obtención de categorías
getCategories();
