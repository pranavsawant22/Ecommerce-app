export default {
    name: 'Tv',
    title: 'Tv',
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
        name: 'display',
        title: 'display',
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
        name: 'description',
        title: 'description',
        type: 'string', 
      },
      {
        name: 'ScreenSize',
        title: 'ScreenSize',
        type: 'text',
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