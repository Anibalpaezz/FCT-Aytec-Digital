const fs = require('fs');
const axios = require('axios');

async function ablancodev_get_categories() {
     try {
          const response = await axios.get('https://tienda.mercadona.es/api/categories/');
          const data = response.data;

          if (data) {
               for (const category of data.results) {
                    fs.appendFileSync('productos3.txt', `ID: ${category.id}, Nombre: ${category.name}, Thumbnail: ${category.thumbnail}\n`);
                    await ablancodev_get_category(category.id);
               }
          }
     } catch (error) {
          fs.appendFileSync('productos3.txt', `Error fetching categories: ${error}\n`);
     }
}

async function ablancodev_get_category(category_id) {
     try {
          const response = await axios.get(`https://tienda.mercadona.es/api/categories/${category_id}`);
          const data = response.data;

          if (data) {
               if (data.categories) {
                    for (const cat_info of data.categories) {
                         fs.appendFileSync('productos3.txt', `ID: ${cat_info.id}, Nombre: ${cat_info.name}, Thumbnail: ${cat_info.thumbnail}\n`);
                         if (cat_info.products) {
                              for (const product of cat_info.products) {
                                   fs.appendFileSync('productos3.txt', `ID: ${product.id}, Nombre: ${product.display_name}, Precio: ${product.price_instructions.unit_price}€, Thumbnail: ${product.thumbnail}\n`);
                              }
                         }
                         await ablancodev_get_category(cat_info.id);
                    }
               }
          }
     } catch (error) {
          fs.appendFileSync('productos3.txt', `Error fetching category: ${error}\n`);
     }
}

ablancodev_get_categories();
