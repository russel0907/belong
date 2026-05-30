import express from "express";

const app = express();
const port = process.env.PORT || 3001;

app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ status: "ok", service: "belong-api" });
});

app.listen(port, () => {
  console.log(`Belong API server running on port ${port}`);
});

export default app;
