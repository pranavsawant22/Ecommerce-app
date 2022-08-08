export default {
    name: 'Apparels',
    title: 'Apparels',
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
        name: 'gender',
        title: 'Gender',
        type: 'string',
      },
      {
        name: 'Color',
        title: 'Color',
        type: 'string',
      },
      {
        name: 'size',
        title: 'size',
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