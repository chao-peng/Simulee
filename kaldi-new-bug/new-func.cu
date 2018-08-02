__global__
void _copy_low_upp(float* A, int rows, int stride) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int j = blockIdx.y * blockDim.y + threadIdx.y;
  if (i <= j || i >= rows)
    return;
  int index_1 = i * stride + j;
  int index_2 = j * stride + i;
  A[index_2] = A[index_1];
}
// rows = 5, stride = 0, block = (2, 1, 1), thread = (3, 2, 2)
// (0, 0, 0) (1, 0, 1) with (0, 0, 0) (1, 0, 0)
// i = 1, j = 0, index_1 = 0, index_2 = 1; i = 1, j = 0, index_1 = 0, index_2 = 1
// (2, 1, 0) read, (1, 0, 1) write. (1 0 1) write to 1, (2 1 0) read from 1 



__global__
void _copy_upp_low(float* A, int rows, int stride) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int j = blockIdx.y * blockDim.y + threadIdx.y;
  if (j <= i || j >= rows)
    return;
  int index_1 = i * stride + j;
  int index_2 = j * stride + i;
  A[index_2] = A[index_1];
}


__global__
void _add_diag_vec_mat(float alpha, float *mat, int stride, int rows, int cols,
                              const float *vec, const float *mat2,
                              int mat2_row_stride, int mat2_col_stride,
                              float beta) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;  
  int j = blockIdx.y * blockDim.y + threadIdx.y;  

  int index = j * stride + i, index2 = j * mat2_row_stride
      + i * mat2_col_stride;

  if (i < cols && j < rows) {
    mat[index] = alpha * vec[j] * mat2[index2] + beta * mat[index];
  }
}