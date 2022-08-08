export default {
    name: 'Books',
    title: 'Books',
    type: 'document',
    fields: [
      {
        name: 'productskuName',
        title: 'productskuName',
        type: 'string', 
      },
      {
        name: 'publisher',
        title: 'publisher',
        type: 'string', 
      },
      {
        name: 'skuId',
        title: 'skuId',
        type: 'string', 
      },
      {
        name: 'price',
        title: 'Price',
        type: 'number',
      },
      {
        name: 'type',
        title: 'Type',
        type: 'string',
      },
      {
        name: 'genre',
        title: 'genre',
        type: 'string',
      },
      {
        name: 'language',
        title: 'language',
        type: 'string',
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
        name: 'author',
        title: 'author',
        type: 'string',
      },
      {
        name: 'description',
        title: 'description',
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