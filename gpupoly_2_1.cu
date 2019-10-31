#include <iostream>
#include <chrono>

int main(int argc, char *argv[])
{

    if (argc < 3)
    {
        std::cerr << "usage: " << argv[0] << " n degree" << std::endl;
        return -1;
    }

    int n = atoi(argv[1]); //TODO: atoi is an unsafe function
    int degree = atoi(argv[2]);
    int nbiter = atoi(argv[3]);

    float *array = new float[n];
    float *poly = new float[degree + 1];
    for (int i = 0; i < n; ++i)
        array[i] = 1.;

    for (int i = 0; i < degree + 1; ++i)
        poly[i] = 1.;

    float *d_array, *d_poly;

    cudaMalloc((void **)&d_array, n * sizeof(float));
    cudaMalloc((void **)&d_poly, (degree + 1) * sizeof(float));

    std::chrono::time_point<std::chrono::system_clock> begin, end;
    begin = std::chrono::system_clock::now();

    for (int iter = 0; iter < nbiter; ++iter)
        cudaMemcpy(d_array, array, n * sizeof(float), cudaMemcpyHostToDevice);

    end = std::chrono::system_clock::now();
    std::chrono::duration<double> totaltime = (end - begin);
    /*cudaMemcpy(d_poly, poly, (degree + 1) * sizeof(float), cudaMemcpyHostToDevice);



    for (int iter = 0; iter < nbiter; ++iter)
        polynomial_expansion<<<(n + BLOCKSIZE - 1) / BLOCKSIZE, BLOCKSIZE>>>(d_poly, degree, n, d_array);

    cudaDeviceSynchronize();
    cudaMemcpy(array, d_array, n * sizeof(float), cudaMemcpyDeviceToHost);
    */
    cudaFree(d_array);
    cudaFree(d_poly);
    /*end = std::chrono::system_clock::now();
    std::chrono::duration<double> totaltime = (end - begin) / nbiter;

    {
        bool check = true;
        int index;
        for (int i = 0; i < n; ++i)
        {
            if (fabs(array[i] - (degree + 1)) > 0.01)
            {
                check = false;
                index = i;
				break;
            }
        }
        if (!check)
            std::cerr << "Polynomial expansion has corrupted at array[" << index << "]" << std::endl;
    }

    std::cerr << array[0] << std::endl;
    std::cout << n << " " << degree << " " << totaltime.count() << std::endl;*/

    std::cout << "Latency of "<< nbiter <<"times is" << totaltime.count() << std::endl;
    std::cout << "Latency of PCI express is" << totaltime.count() / nbiter << std::endl;

    delete[] array;
    delete[] poly;

    return 0;
}