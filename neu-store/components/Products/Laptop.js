import { ListItem, Typography } from "@mui/material";
import React from "react";

const Laptop = ({props}) => {

  return (
    <>
      <ListItem>
        <Typography>Description: {props.description}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Camera: {props.camera}</Typography>
      </ListItem>
      <ListItem>
        <Typography>RAM: {props.RAM}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Storage: {props.storage}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Display: {props.display}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Processor: {props.processor}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Graphics Card: {props.graphicscard}</Typography>
      </ListItem>
    </>
  );
};

export default Laptop;
