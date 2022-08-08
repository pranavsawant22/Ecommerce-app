import { bool } from "prop-types";

export default {
    name: 'product',
    title: 'Product',
    type: 'document',
    fields: [
      {
        name: 'name',
        title: 'Name',
        type: 'string',
      },
      {
        name: 'productId',
        title: 'Product Id',
        type: 'string',
      },
      {
        name: 'image',
        title: 'Image',
        type: 'image',
        options: {
          hotspot: true,
        },
      },
      {
        name: 'productAdImage',
        title: 'productAdImage',
        type: 'image',
      },
      {
        name: 'isAdvertised',
        title: 'isAdvertised',
        type: 'boolean',
      },
      {
        name: 'description',
        title: 'Description',
        type: 'string',
      },
      {
        name: 'brand',
        title: 'Brand',
        type: 'string',
      },
      {
        name: 'rating',
        title: 'Rating',
        type: 'number',
      },
      {
        name: 'catagory',
        type: 'object',
        fields: [ 
            {
            name : 'productsku',
            title: 'poductSKU',
            type : 'catagory'
            }
        ],
      },
    ],
  };