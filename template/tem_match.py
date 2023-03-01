import numpy as np

def spike_template_matching(spike_matrix, precision=1):
    '''
    :param spike_matrix: numpy array, 每行对应每个神经元出现的所有spike时间点
    :param precision: int, 匹配的精度，默认为1ms
    :return: numpy array, 匹配后得到的所有相似的spike对的列表，每个元素为一个列表，包含相似的spike的时间戳和电极编号
    '''
    templates = []
    for i in range(spike_matrix.shape[0]):
        spikes = spike_matrix[i]
        for t in spikes:
            template = np.concatenate([spikes[(spikes >= t) & (spikes <= t + 200)] - t,
                                        np.ones(np.sum((spikes >= t) & (spikes <= t + 200))) * i])
            templates.append(template)
    templates = np.array(templates)

    matches = []
    for i in range(templates.shape[0]):
        for j in range(i+1, templates.shape[0]):
            if templates[i][-1] == templates[j][-1]:  # 检查是否来自同一电极
                diffs = templates[i][:-1] - templates[j][:-1]
                if (np.abs(diffs) <= precision).sum() >= 3:  # 检查时间差是否在给定精度内且匹配的spike数是否大于等于3
                    matches.append([templates[i][:-1][np.abs(diffs) <= precision],
                                    templates[i][-1]])
                    matches.append([templates[j][:-1][np.abs(diffs) <= precision],
                                    templates[j][-1]])

    return matches


spike_matrix=np.mat('1 2 3;4 5 6;7 8 9')

spike_template_matching(spike_matrix,1)



# import numpy as np
#
# # read spike data from file
# with open('spike_data.txt', 'r') as f:
#     lines = f.readlines()
#
# # create a dictionary to store spike times for each neuron
# spike_times = {}
# for i, line in enumerate(lines):
#     spike_times[i] = np.array([float(x) for x in line.split()])
#
# # set the template duration to 200 ms
# template_duration = 0.2
#
# # specify the matching precision in milliseconds
# matching_precision = 1
#
# # initialize a list to store all matching pairs of spikes
# matches = []
#
# # loop through each neuron
# for neuron in spike_times:
#     # loop through each spike time in this neuron
#     for i, t_i in enumerate(spike_times[neuron]):
#         # create a template for this spike
#         template_i = []
#         for j, t_j in enumerate(spike_times[neuron]):
#             if t_j >= t_i and t_j < t_i + template_duration:
#                 template_i.append((t_j - t_i, neuron))
#         # loop through all other spikes on this neuron
#         for j in range(i+1, len(spike_times[neuron])):
#             t_j = spike_times[neuron][j]
#             # create a template for this spike
#             template_j = []
#             for k, t_k in enumerate(spike_times[neuron]):
#                 if t_k >= t_j and t_k < t_j + template_duration:
#                     template_j.append((t_k - t_j, neuron))
#             # compare the two templates for a match
#             num_matches = 0
#             for ti, ei in template_i:
#                 for tj, ej in template_j:
#                     if ei == ej and abs(ti - tj) <= matching_precision / 1000:
#                         num_matches += 1
#             if num_matches >= 3:
#                 matches.append((t_i, t_j))
#
# # sort the matches by the time of the first spike in each pair
# matches.sort()
#
# # print the number of matches found
# print(len(matches))