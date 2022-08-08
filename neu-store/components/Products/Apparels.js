import { ListItem, Typography } from "@mui/material";
import React from "react";

const Apparels = ({props}) => {
  return (
    <>
      <ListItem>
        <Typography>Description: {props.description}</Typography>
      </ListItem>
      <ListItem>
        <Typography>For : {props.gender}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Size: {props.size}</Typography>
      </ListItem>
    </>
  );
};

export default Apparels;
