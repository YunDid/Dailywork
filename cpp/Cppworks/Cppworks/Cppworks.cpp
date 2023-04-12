#include <iostream>
#include <string>
#include <filesystem>

namespace fs = std::filesystem;

int main() {
    std::string path = "./"; // 更改为你自己的目录路径
    std::string old_name = "oldname.txt"; // 要更改的文件名
    std::string new_name = "newname.txt"; // 更改后的文件名

    for (auto& entry : fs::directory_iterator(path)) {
        if (entry.is_regular_file() && entry.path().extension() == ".txt") {
            std::string file_name = entry.path().filename().string();
            if (file_name == old_name) {
                fs::path new_path = entry.path().parent_path() / new_name;
                fs::rename(entry.path(), new_path);
                std::cout << "Renamed file " << old_name << " to " << new_name << std::endl;
            }
        }
    }

    return 0;
}



// 1-10 22-30 42-50