// Enable C++11 via this plugin 
// [[Rcpp::plugins("cpp11")]]

// [[Rcpp::depends(Rcereal)]]
// [[Rcpp::depends(BH)]]

#include <boost/iostreams/stream.hpp>
#include <boost/iostreams/device/array.hpp>
#include <cereal/archives/binary.hpp>
#include <Rcpp.h>

struct MyClass {
    int x, y, z;

    // This method lets cereal know which data members to serialize
    template<class Archive>
    void serialize(Archive & archive) {
        archive( x, y, z ); // serialize things by passing them to the archive
    }
};

using namespace Rcpp;

//[[Rcpp::export]]
RawVector serialize_myclass(int x = 1, int y = 2, int z = 3) {
    MyClass my_instance;
    my_instance.x = x;
    my_instance.y = y;
    my_instance.z = z;
    RawVector retval(100);
    boost::iostreams::stream_buffer<boost::iostreams::array_sink> buf((char*) &retval[0], retval.size());
    std::ostream ss(&buf); {
        cereal::BinaryOutputArchive oarchive(ss);
        oarchive(my_instance);
    }
    return retval;
}

//[[Rcpp::export]]
void deserialize_myclass(RawVector src) {
    boost::iostreams::stream<boost::iostreams::array_source> ss((char*) &src[0], src.size());
    MyClass my_instance; {
        cereal::BinaryInputArchive iarchive(ss);
        iarchive(my_instance);
    }
    Rcout << my_instance.x << "," << my_instance.y << "," << my_instance.z << std::endl;
}