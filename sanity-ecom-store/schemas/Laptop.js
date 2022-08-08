export default {
    name: 'Laptop',
    title: 'Laptop',
    type: 'document',
    fields: [
      {
        name: 'productskuName',
        title: 'productskuName',
        type: 'string', 
      },
      {
        name: 'skuId',
        title: 'skuId',
        type: 'string', 
      },
      {
        name: 'RAM',
        title: 'RAM',
        type: 'string',
      },
      {
        name: 'Color',
        title: 'COLOR',
        type: 'string',
      },
      {
        name: 'storage',
        title: 'Storage',
        type: 'string',
      },
      {
        name: 'display',
        title: 'Display',
        type: 'string',
      },
      {
        name: 'price',
        title: 'Price',
        type: 'number',
      },
      {
        name: 'countInStock',
        title: 'countInStock',
        type: 'number',
      },
      {
        name: 'image',
        title: 'Image',
        type: 'image',
      },
      {
        name: 'camera',
        title: 'Camera',
        type: 'string',
      },
      {
        name: 'description',
        title: 'description',
        type: 'string', 
      },
      {
        name: 'processor',
        title: 'processor',
        type: 'string', 
      },
      {
        name: 'graphicscard',
        title: 'graphicsCard',
        type: 'string', 
      },
      {
        name: 'slug',
        title: 'Slug',
        type: 'slug',
        options: {
          source: 'skuid',
          maxLength: 96,
        },
      },
    ],
  };