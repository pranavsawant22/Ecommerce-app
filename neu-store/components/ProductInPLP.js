import {
  Button,
  Card,
  CardActionArea,
  CardActions,
  CardContent,
  CardMedia,
  Rating,
  Typography,
} from "@mui/material";
import NextLink from "next/link";
import React from "react";

export default function ProductInPLP({ product }) {
  const kind = toTitleCase(product.kind);

  function toTitleCase(str) {
    return str
      .toLowerCase()
      .split(" ")
      .map(function (word) {
        return word.charAt(0).toUpperCase() + word.slice(1);
      })
      .join(" ");
  }

  return (
    <Card>
      <NextLink href={`/product/${kind}:${product.slug}`} passHref>
        <CardActionArea>
          <CardMedia
            component="img"
            image={product.image_url}
            title={product.productSkuName}
            layout="responsive"
            width={400}
            height={400}
          ></CardMedia>
          <CardContent>
            <Typography>{product.productSkuName}</Typography>
            <Rating value={product.rating} readOnly></Rating>
          </CardContent>
        </CardActionArea>
      </NextLink>
      <CardActions>
        <Typography>₹ {product.price}</Typography>
      </CardActions>
    </Card>
  );
}
