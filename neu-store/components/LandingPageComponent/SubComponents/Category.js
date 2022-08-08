import {
  Card,
  CardActions,
  CardContent,
  CardMedia,
  Typography,
  Button,
  CircularProgress,
  Alert,
} from "@mui/material";
import { Box } from "@mui/system";
import styles from "../../../styles/Category.module.css";
import { useRouter } from "next/router";
import { Fragment, useEffect, useState } from "react";
import { urlForThumbnail } from "../../../utils/image";
import client from "../../../utils/client";

export default function CategorySection() {
  const routerObj = useRouter();

  const [state, setState] = useState({
    categories: [],
    error: "",
    loading: true,
  });

  const { categories, error, loading } = state;
  useEffect(() => {
    const fetchCategory = async () => {
      try {
        const category = await client.fetch('*[_type == "catagory"]');
        if (category.length !== 0) {
          setState({
            categories: category,
            loading: false,
          });
        } else {
          setState({
            error: error.message,
            loading: false,
          });
        }
      } catch (error) {
        console.log(error.message);
        setState({
          loading: false,
          error: error.message,
        });
      }
    };
    fetchCategory();
  }, []);

  function onCatergoryClickHandler(query) {
    routerObj.push(`/search?query=${query}`);
  }

  return (
    <Fragment>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="danger">{error}</Alert>
      ) : (
        <div className={styles.cat__poster}>
          <div className={styles.cat__posters}>
            {categories.map((categoriesList) => (
              <Box onClick={() => onCatergoryClickHandler(categoriesList.kind)}>
                <Card className={styles.cat__card}>
                  <CardMedia
                    component="img"
                    height="160"
                    image={urlForThumbnail(categoriesList.categoryImage)}
                    alt={categoriesList.kind}
                  ></CardMedia>
                  <CardActions>
                    <Button size="small" onClick={null}>
                      {categoriesList.kind}
                    </Button>
                  </CardActions>
                </Card>
              </Box>
            ))}
          </div>
        </div>
      )}
    </Fragment>
  );
}
