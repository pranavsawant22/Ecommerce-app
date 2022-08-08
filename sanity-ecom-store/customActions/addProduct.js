import Typesense from 'typesense'

const API_KEY = process.env.SANITY_STUDIO_API_KEY
const HOST = process.env.SANITY_STUDIO_HOST
const PORT = process.env.SANITY_STUDIO_PORT
const PROTOCOL = process.env.SANITY_STUDIO_PROTOCOL

const addProduct = async (doc) => {  
  if(doc.type === "product"){
    // preprocess doc
    const sku = Object.values(Object.values(doc.draft.catagory.productsku)[0])[0]
    
    const product = {}
    product.name = doc.draft.name
    product.brand = doc.draft.brand
    product.rating = doc.draft.rating
    product.kind = doc.draft.catagory.productsku.kind
    product.description = sku.description
    product.productSkuName = sku.productskuName
    product.price = sku.price
    product.slug = sku.slug.current
    
    if(product.kind === "Apparels"){
      product.gender = sku.gender  
    }
    
    const urlArray = sku.image.asset._ref.split("-")
    product.image_url = urlArray==null?null:"https://cdn.sanity.io/images/g71nhdwa/production/"+urlArray[1]+"-"+urlArray[2]+"."+urlArray[3]
    
    // typesense client
    const client = new Typesense.Client({
      nodes: [
        {
          host: HOST,
          port: PORT,
          protocol: PROTOCOL
        }
      ],
      apiKey: API_KEY,
      connectionTimeoutSeconds: 2,
    })

    // delete the existing doc in typesense if it exists
    try {
      const result = await client.collections('products').documents().delete({'filter_by': `slug:${product.slug}`})
    } catch (err) {
      console.log('typesense delete error',err)
    }

    // add the new doc
    try {
      const result = await client.collections('products').documents().create(product)
    } catch (err) {
      console.log('typesense create error : ',err) 
    }
  }
}

export default addProduct